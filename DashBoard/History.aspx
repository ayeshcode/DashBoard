<%--<%@ Page Title="" Language="C#" MasterPageFile="~/SeleniumWebApp.Master" AutoEventWireup="true" CodeBehind="History.aspx.cs" Inherits="JS_Grid.History" %>--%>

<%@ Register TagPrefix="telerik" Namespace="Telerik.Web.UI" Assembly="Telerik.Web.UI" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <style>
        #ctl00_ContentPlaceHolder1_RadGrid2_ctl00 {
            border-radius: 10px;
            width: 500px;
        }

        td {
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
            max-width: 100px;
        }

            td:hover {
                white-space: normal;
            }

        .bu {
            background-color: red;
        }
    </style>


    <script>

        $(document).ready(function () {

            
            var errorModal = document.getElementById("errorModal");
            var isOrderChnaged = document.getElementById("txtIsOrderChanged").value;

            if (isOrderChnaged == "True"){
                errorModal.style.display = "block";

            }



            var closeErrorModal = document.getElementsByClassName("close")[0];

            closeErrorModal.onclick = function () {
                errorModal.style.display = "none";
            }

            window.onclick = function (event) {
                if (event.target == errorModal) {
                    errorModal.style.display = "none";
                }
            }

            if ($("#ddlScenario").val() == "Select Scenario") {

                document.getElementById("ddlExecutedTime").style.display = "none";
                document.getElementById("lblExecutedTime").style.display = "none";

            }


            $("#ddlScenario").change(function () {
                if ($("#ddlScenario").val() != "Select Scenario") {
                    document.getElementById("txtScenario").value = $("#ddlScenario").val();
                }
            });

            $("#ddlExecutedTime").change(function () {
                if ($("#ddlExecutedTime").val() != "Select Executed Time") {
                    document.getElementById("txtExecutedTime").value = $("#ddlExecutedTime").val();
                }
            });
        })


    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="pageTitle" runat="server">
    <h2 class=" navbar-left navbar-brand">Test Result History</h2>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="mainContainer">
        <div id="scenarioProgressDetails">
            <div id="errorModal" class="modal" runat="server">

                <div class="modal-content">
                    <span class="close">&times;</span>
                    <h3 id="errorScreenshot">Test case has been updated! Therefore comparison may be imprecise. </h3>
                </div>

            </div>

            <div id="scenarioDetails">
                <table style="width: 100%; color: #21415b;">
                    <tr>
                        <td style="font-weight: 600; padding: 10px 10px 10px 250px">Latest Results</td>
                        <td style="font-weight: 600">Previous Results</td>
                    </tr>

                </table>
                <p></p>
            </div>
        </div>


        <div hidden>
            <asp:TextBox ID="txtScenario" runat="server" OnTextChanged="txtScenario_TextChanged"></asp:TextBox>
            <asp:TextBox ID="txtExecutedTime" runat="server" OnTextChanged="txtExecutedTime_TextChanged"></asp:TextBox>
            <asp:TextBox ID="txtIsOrderChanged" runat="server"></asp:TextBox>
        </div>




        <telerik:RadScriptManager runat="server" ID="RadScriptManager1" />
        <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server">
        </telerik:RadAjaxManager>

        <div class="demo-container no-bg">
            <telerik:RadGrid RenderMode="Lightweight" runat="server" ID="RadGrid2" AllowPaging="True" OnItemDataBound="RadGrid2_ItemDataBound"
                OnNeedDataSource="RadGrid2_NeedDataSource" AutoGenerateColumns="false" HeaderStyle-BackColor="#a8d3ff" HeaderStyle-Font-Bold="true">
                <MasterTableView HeaderStyle-BackColor="#a8d3ff" HeaderStyle-Font-Bold="true">
                    <Columns>
                        <telerik:GridBoundColumn DataField="Scenario" DataType="System.String" HeaderText="Scenario"
                            ReadOnly="True" UniqueName="Scenario">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="TestDescription" DataType="System.String" HeaderText="Description"
                            SortExpression="TestDescription" UniqueName="TestDescription">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="ElementName" DataType="System.String" HeaderText="Element"
                            SortExpression="ElementName" UniqueName="ElementName">
                        </telerik:GridBoundColumn>
                      
                        <telerik:GridBoundColumn DataField="TestStatus" DataType="System.String" HeaderText="Status"
                            SortExpression="TestStatus" UniqueName="TestStatus">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="dummy" DataType="System.String" HeaderText=" "
                            SortExpression="dummy" UniqueName="dummy" ItemStyle-BackColor="#bfbfbf" HeaderStyle-BackColor="#bfbfbf" HeaderStyle-ForeColor="#bfbfbf">
                        </telerik:GridBoundColumn>

                        <telerik:GridBoundColumn DataField="Scenario2" DataType="System.String" HeaderText="Scenario"
                            ReadOnly="True" SortExpression="Scenario2" UniqueName="Scenario2">
                        </telerik:GridBoundColumn>
                        <telerik:GridBoundColumn DataField="TestDescription2" DataType="System.String" HeaderText="Description"
                            SortExpression="TestDescription2" UniqueName="TestDescription2">
              
                    </Columns>

                </MasterTableView>
            </telerik:RadGrid>
        </div>
    </div>
</asp:Content>
