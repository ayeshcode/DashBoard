

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>
<%@ Register Assembly="Telerik.Web.UI" Namespace="Telerik.Web.UI" TagPrefix="telerik" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style type="text/css">
        #RadTreeList1 {
            background-color: aqua;
            border-radius: 30px;
        }
        
        .footerAlign{
            align-items:center;
            padding:6px 6px 6px 6px;
            text-align:right;
        }
        #btnStopExecution{
           float:right;
        }
        td {
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
        }

            td:hover {
                white-space: normal;
                cursor: pointer;
            }
    </style>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="pageTitle" runat="server">
    <h2 class=" navbar-left navbar-brand">Selenium Dashboard</h2>

    <div class="navbar-left navbar-brand">
        <asp:Button ID="BtnExportExcel" runat="server" Text="Export to Excel" OnClick="BtnExportExcel_Click" class="btn btn-primary navbar-btn" />
        <asp:Button ID="BtnExportHTML" runat="server" Text="Export to HTML" OnClick="BtnExportHTML_Click" class="btn btn-primary navbar-btn" />


    </div>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="mainContainer">
        <div id="scenarioProgressDetails">
            <div id="scenarioDetails">
            </div>

            <div id="scenarioProgress" class="progress" runat="server" hidden>
                <div id="scenarioProgressBar" class="progress-bar progress-bar-striped progress-bar-animated"></div>
            </div>
        </div>


         <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="ctl00_ContentPlaceHolder1_ctl00" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
               <telerik:RadAjaxLoadingPanel ID="RadAjaxLoadingPanel1" runat="server" MinDisplayTime="0"></telerik:RadAjaxLoadingPanel>
                <telerik:RadTreeList AllowMultiColumnSorting="true" CssClass="table-primary" AllowSorting="true" RenderMode="Lightweight" EnableTheming="true" OnNeedDataSource="RadTreeList1_NeedDataSource" 
                    runat="server" ID="RadTreeList1" PageSize="10" DataKeyNames="ParentID"
                    ParentDataKeyNames="Scenario" AllowNaturalSort="true" AutoGenerateColumns="false" Height="100%" ondblclick="ShowScreenshot()"
                    HeaderStyle-BackColor="#a8d3ff" HeaderStyle-Font-Bold="true">
                    <Columns>
                        <telerik:TreeListBoundColumn DataField="ParentID" UniqueName="ParentID" HeaderText="Scenario">
                        </telerik:TreeListBoundColumn>
                        <telerik:TreeListBoundColumn DataField="PageName" UniqueName="Page Name" HeaderText="Page Name">
                        </telerik:TreeListBoundColumn>
                        <telerik:TreeListBoundColumn DataField="TestDescription" UniqueName="TestDescription" HeaderText="Description">
                        </telerik:TreeListBoundColumn>
                        <telerik:TreeListBoundColumn DataField="ElementName" UniqueName="ElementName" HeaderText="Element">
                        </telerik:TreeListBoundColumn>
                        <telerik:TreeListBoundColumn DataField="LastUpdated" UniqueName="LastUpdated" HeaderText="Execution Time" DataType="System.DateTime" DataFormatString="{0:HH:mm:ss - dd MMM, yyyy}">
                        </telerik:TreeListBoundColumn>
                        <telerik:TreeListBoundColumn DataField="TestStatus" UniqueName="TestStatus" HeaderText="Status">
                        </telerik:TreeListBoundColumn>
                    </Columns>
                </telerik:RadTreeList>

            </ContentTemplate>
            <Triggers>
              <asp:AsyncPostBackTrigger ControlID="Timer1" EventName="Tick" />
            </Triggers>

             
        </asp:UpdatePanel>
        <asp:Timer ID="Timer1" runat="server" Interval="2000" OnTick="Timer1_Tick"></asp:Timer>
        <%-- <telerik:RadScriptManager runat="server" ID="RadScriptManager1" />--%>
        <%--<telerik:RadSkinManager ID="RadSkinManager1" runat="server" ShowChooser="true" />--%>

       
        
        <div class="footerAlign" runat="server">
            <asp:Button ID="btnStopExecution" runat="server" Text="Stop Execution" CssClass="btn btn-danger" OnClick="btnStopExecution_Click" Visible="false"/>
            </div>    
       
        
        
        <div id="screenshotPopup" class="modal" runat="server">
            <div class="modal-content">
                <span class="close">&times;</span>
               <a id="urlLink" href="url" target="_blank"> <h4 id="url"> </h4></a> 
                <img id="imgScreenshot" src="ScreenshotPath" />
                <h5 id="screenshotTitle">Test</h5>
                <p hidden>Some text in the Modal..</p>
            </div>

        </div>

        <div id="errorModal" class="modal">

            <div class="modal-content">
                <span class="close">&times;</span>
                <h3 id="errorScreenshot">Screenshot is not available! Please contact the automation team for support. </h3>
            </div>

        </div>

        <asp:HiddenField ID="HiddenStatus" runat="server" />
        <asp:HiddenField ID="HiddenExecutionStatus" runat="server" />


    </div>
    <script>



      
        //--------------------------------Progress Bar------------------------------------------------------------------------

        function showProgressBar() {
            if ($("#ddlUserName").val() == "Select User" || $("#ddlUserName").val() == "ALL") {
                document.getElementById("scenarioProgress").style.display = "none";
                document.getElementById("scenarioProgressBar").style.display = "none";
                document.getElementById("scenarioDetails").style.display = "none";
                document.getElementById("btnStopExecution").style.display = "none";
            }
            else {
                document.getElementById("btnStopExecution").style.display = "block";
                document.getElementById("scenarioProgress").style.display = "block";
                document.getElementById("scenarioProgressBar").style.display = "block";
                document.getElementById("scenarioDetails").style.display = "block";
                getScenarioDetails();
            }
        }

        function getScenarioDetails() {

            return $.ajax({
                type: "POST",
                url: "./Authorised/RetrieveScenarioData.ashx?UserName=" + $('#ddlUserName').val(),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (data) {

                    var name = data[0]["ScenarioName"];
                    var total = data[0]["TotalCount"];
                    var current = (data[0]["CurrentCount"]);

                    if ((total == 0) && (current == 0)) {
                        $("#scenarioDetails").html("");
                        document.getElementById("scenarioProgress").style.display = "none";
                    }
                    else {
                        $("#scenarioDetails").html("");
                        var scenarioDetails = $("#scenarioDetails").append("<p>" + "Executing Scenario : " + name + "</p>");
                        var progress = (current / total) * 100;
                        $("#scenarioProgressBar").width(progress + '%');
                        $("#scenarioProgressBar").text(current + " / " + total);
                        if (current == total) {
                            $("#scenarioDetails").html("");
                            $("#scenarioDetails").append("<p>Completed</p>");
                            $("#scenarioProgressBar").css("animation", "none");
                            document.getElementById("btnStopExecution").style.display = "none";
                            document.getElementById("HiddenExecutionStatus").value = "Completed";
                        }
                    }

                },
                failure: function (response) {
                    alert(response.d);
                }

            });
            return scenarioDetails;
        }

        //--------------------------------Export to excel------------------------------------------------------------------------

        var status = document.getElementById("HiddenStatus").value;

        function JSONToCSVConvertor(JSONData, ReportTitle, ShowLabel) {
            debugger
            //If JSONData is not an object then JSON.parse will parse the JSON string in an Object
            if (JSONData == "") {
                alert("Please Select a User to Download Status Report");
            }

            var arrData = typeof JSONData != 'object' ? JSON.parse(JSONData) : JSONData;
            var CSV = '';
            //Set Report title in first row or line

            CSV += ReportTitle + '\r\n\n';

            //This condition will generate the Label/Header
            if (ShowLabel) {

                var row = "";

                //This loop will extract the label from 1st index of on array
                for (var index in arrData[0]) {

                    //Now convert each value to string and comma-seprated
                    row += index + ',';
                }

                row = row.slice(0, -1);

                //append Label row with line break
                CSV += row + '\r\n';
            }

            //1st loop is to extract each row
            for (var i = 0; i < arrData.length; i++) {
                var row = "";

                //2nd loop will extract each column and convert it in string comma-seprated
                for (var index in arrData[i]) {
                    row += '"' + arrData[i][index] + '",';
                }

                row.slice(0, row.length - 1);

                //add a line break after each row
                CSV += row + '\r\n';
            }

            if (CSV == '') {
                alert("Invalid data");
                return;
            }

            //Generate a file name
            var fileName = "MyReport_";
            //this will remove the blank-spaces from the title and replace it with an underscore
            fileName += ReportTitle.replace(/ /g, "_");

            //Initialize file format you want csv or xls
            var uri = 'data:text/csv;charset=utf-8,' + escape(CSV);

            // Now the little tricky part.
            // you can use either>> window.open(uri);
            // but this will not work in some browsers
            // or you will not get the correct file extension    

            //this trick will generate a temp <a /> tag
            var link = document.createElement("a");
            link.href = uri;

            //set the visibility hidden so it will not effect on your web-layout
            link.style = "visibility:hidden";
            link.download = fileName + ".csv";

            //this part will append the anchor tag and remove it after automatic click
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }




    </script>
</asp:Content>
