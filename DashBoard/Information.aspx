<%--<%@ Page Title="" Language="C#" MasterPageFile="~/SeleniumWebApp.Master" AutoEventWireup="true" CodeBehind="Information.aspx.cs" Inherits="JS_Grid.Information" %>--%>


<asp:Content ID="Content4" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">

    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
    <script src="Scripts/core.js"></script>
    <script src="Scripts/charts.js"></script>
    <script src="Scripts/animated.js"></script>
    <script src="Scripts/dataviz.js"></script>
    <script type="text/javascript">


        function LoadPieChart() {

            am4core.ready(function () {

                // Themes begin
                //am4core.useTheme(am4themes_dataviz);
                am4core.useTheme(am4themes_animated);
                // Themes end

                // Create chart
                var chart = am4core.create("pieChart", am4charts.PieChart);
                chart.hiddenState.properties.opacity = 0; // this creates initial fade-in

                let title = chart.titles.create();
                title.text = "Test Status Summary";
                title.fontSize = 20;
                title.marginBottom = 15;
                


                var series = chart.series.push(new am4charts.PieSeries());


                series.dataFields.value = "TestStatusCount";
                series.dataFields.radiusValue = "TestStatusCount";
                series.dataFields.category = "TestStatus";
                series.slices.template.cornerRadius = 6;
                series.colors.step = 3;
                var columnTemplate = series.slices.template;
                columnTemplate.adapter.add("fill", function (fill, target) {
                    if (target.dataItem) {
                        if (target.dataItem.category == "Fail") {
                            return am4core.color("#FF0000")
                        }
                        else if (target.dataItem.category == "Success") {
                            return am4core.color("#40ff00")
                        }

                        else {
                            return am4core.color("#FF0000");
                        }
                    }
                    return fill;
                });

                series.hiddenState.properties.endAngle = -90;
                series.tooltip.label.interactionsEnabled = true;
                series.tooltip.keepTargetHover = true;
                series.tooltip.dy = -120;
                series.slices.template.tooltipHTML = `{TestStatus} \n ({TestStatusCount})
                                                       <hr/>
                                                        <table>
                                                        <tr>
                                                        <div style = "max-height: 160px; overflow: auto;">
                                                        {TestScenarioList}
                                                        </div>
                                                        </tr>
                                                        </table>
                                                        `;

                chart.legend = new am4charts.Legend();

            });
            document.getElementById("errorSummaryStatus").style.display = "none";
            document.getElementById("pieChart").style.display = "block";

            AlignCharts();
        }

        function LoadSeverityChart() {
            if ($("#ddlUserName").val() != "Select User") {

                am4core.ready(function () {
                    // Themes begin
                    am4core.useTheme(am4themes_animated);
                    // Themes end

                    // Create chart
                    var chart = am4core.create("pieChartBySeverity", am4charts.PieChart);
                    chart.hiddenState.properties.opacity = 0; // this creates initial fade-in

                    let title = chart.titles.create();
                    title.text = "Tests Executed By Severity";
                    title.fontSize = 20;
                    title.marginBottom = 15;
                    


                    var series = chart.series.push(new am4charts.PieSeries());


                    series.dataFields.value = "ScenarioCountBySeverity";
                    series.dataFields.radiusValue = "ScenarioCountBySeverity";
                    series.dataFields.category = "Severity";
                    series.slices.template.cornerRadius = 6;
                    series.colors.step = 3;
                    var columnTemplate = series.slices.template;
                    columnTemplate.adapter.add("fill", function (fill, target) {
                        if (target.dataItem) {
                            if (target.dataItem.category == "Critical") {
                                return am4core.color("rgb(153, 0, 0)")
                            }
                            else if (target.dataItem.category == "High") {
                                return am4core.color("rgb(255, 51, 0)")
                            }
                            else if (target.dataItem.category == "Medium") {
                                return am4core.color("rgb(255, 204, 0)")
                            }
                            else if (target.dataItem.category == "Low") {
                                return am4core.color("rgb(102,204, 51)")
                            }
                            else {
                                return am4core.color("#f00");
                            }
                        }
                        return fill;
                    });

                    chart.legend = new am4charts.Legend();
                });

                document.getElementById("pieChartBySeverity").style.display = "block";
                AlignCharts();
            }
        }

        function LoadProductChart() {
            if ($("#ddlUserName").val() != "Select User") {
                am4core.ready(function () {

                    // Themes begin
                    am4core.useTheme(am4themes_dataviz);
                    am4core.useTheme(am4themes_animated);
                    // Themes end

                    // Create chart
                    var chart = am4core.create("pieChartByProduct", am4charts.PieChart);
                    chart.hiddenState.properties.opacity = 0; // this creates initial fade-in

                    let title = chart.titles.create();
                    title.text = "Tests Executed By Product";
                    title.fontSize = 20;
                    title.marginBottom = 15;
                    


                    var series = chart.series.push(new am4charts.PieSeries());

                    series.dataFields.value = "ScenarioCountByProduct";
                    series.dataFields.radiusValue = "ScenarioCountByProduct";
                    series.dataFields.category = "Product";
                    series.slices.template.cornerRadius = 6;
                    series.colors.step = 3;
                    series.hiddenState.properties.endAngle = -90;
                    chart.legend = new am4charts.Legend();
                });

                document.getElementById("pieChartByProduct").style.display = "block";
                AlignCharts();
            }
        }

    </script>
    <script>

        $(document).mouseup(function (e) {
            if ($(e.target).closest("#userListCard").length
                === 0) {
                $("#userListCard").hide();
            }

            if ($(e.target).closest("#scenarioListCard").length
                === 0) {
                $("#scenarioListCard").hide();
            }
        });


        $(document).ready(function () {

            AlignCharts();
            if ($("#ddlUserName").val() == "Select User") {

                document.getElementById("pieChart").style.display = "none";
                document.getElementById("pieChartBySeverity").style.display = "none";
                document.getElementById("pieChartByProduct").style.display = "none";
                document.getElementById("errorSummaryStatus").style.display = "block";
                AlignCharts();
            }
            else {
                LoadPieChart();
            }


            $("#ddlUserName").change(function () {
                if ($("#ddlUserName").val() == "Select User") {
                    document.getElementById("pieChart").style.display = "none";
                    document.getElementById("pieChartBySeverity").style.display = "none";
                    document.getElementById("pieChartByProduct").style.display = "none";
                    document.getElementById("errorSummaryStatus").style.display = "block";
                    AlignCharts();
                }
                else {
                    document.getElementById("pieChartBySeverity").style.display = "none";
                    document.getElementById("pieChartByProduct").style.display = "none";
                    LoadPieChart();
                    LoadPieChart();
                    move();
                }
            });

        })

        function AlignCharts() {

            var num = $(".col-lg-4:visible").length;


            switch (num) {
                case 0:
                    $('.col-lg-4').css('margin', 'transparent');
                    break;
                case 1:
                    $('.col-lg-4').css('margin', 'transparent');
                    $('.col-lg-4').css('margin', 'transparent');
                    $('.col-lg-4').css('margin', '30px 200px 30px 440px');
                    break;
                case 2:
                    $('.col-lg-4').css('margin', 'transparent');
                    $('.col-lg-4').css('margin', '30px 100px 30px 120px');
                    break;
                case 3:
                    $('.col-lg-4').css('margin', 'transparent');
                    $('.col-lg-4').css('margin', '30px 5px 30px 5px');
                    break;
            }

        }

        function ShowUserList() {

            document.getElementById("userListCard").style.display = "block";
        };

        function ShowScenarioList() {

            document.getElementById("scenarioListCard").style.display = "block";
        };

    </script>

</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="pageTitle" runat="server">
    <h2 class=" navbar-left navbar-brand">Information Dashboard</h2>
</asp:Content>

<asp:Content ID="Content6" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <div class="container-fluid">
        <div class="row">
            <div class="col-md-3">
                <div class="card tile">
                    <div class="card-body">
                        <i class="fas fa-users roundIcon1" aria-hidden="true"></i>
                        <div class="title">
                            <h4 id="numOfUsers" runat="server" class="statNumber">2</h4>
                        </div>
                        <div class="text">
                            <p>Today's Users</p>
                        </div>
                        <i class="fas fa-caret-down icon" id="btnUser" aria-hidden="true" onclick="ShowUserList()"></i>
                        <div class="card innercard">
                            <div class="card-body" id="userListCard" hidden>
                                <ul id="ulUserList" runat="server"></ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card tile">
                    <div class="card-body">

                        <i class="fas fa-tasks roundIcon2" aria-hidden="true"></i>

                        <div class="title">
                            <h4 id="numOfTests" class="statNumber" runat="server">2</h4>
                        </div>

                        <div class="text">
                            <p>Today's Executed Tests</p>
                        </div>

                        <i class="fas fa-caret-down icon" id="btnScenario" aria-hidden="true" onclick="ShowScenarioList()"></i>

                        <div class="card innercard">
                            <div class="card-body" id="scenarioListCard" hidden>
                                <ul id="ulScenarioList" runat="server"></ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>


            <div class="col-md-3" id="severityCard" onclick="LoadProductChart();LoadProductChart()">
                <div class="card tile">
                    <div class="card-body">
                        <i class="fas fa-briefcase roundIcon3" aria-hidden="true"></i>


                        <div class="title">
                            <h4 id="titleProduct" runat="server">Tests Executed by Product</h4>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3" onclick="LoadSeverityChart();LoadSeverityChart();">
                <div class="card tile">
                    <div class="card-body">
                        <i class="fas fa-exclamation-triangle roundIcon4" aria-hidden="true"></i>

                        <div class="title">
                            <h4 id="titleSeverity" runat="server">Tests Executed by Severity</h4>
                        </div>


                    </div>
                </div>
            </div>
        </div>
    </div>


    <div class="mainContainer">

        <p style='color: red; margin-top: 5px; margin-left: 10px; position: absolute; text-align: center;' id="errorSummaryStatus" hidden runat="server">Select User to View the Summary Charts.</p>

        <div class="row align-items-center rowCharts" id="divCharts" style="margin-left: 3px;">

            <div id="pieChartByProduct" class="col-lg-4" hidden>
                <i class="fa fa-times icon" aria-hidden="true"></i>

            </div>

            <div id="pieChart" class="col-lg-4" hidden>
            </div>

            <div id="pieChartBySeverity" class="col-lg-4" hidden>
            </div>
        </div>

    </div>



</asp:Content>
