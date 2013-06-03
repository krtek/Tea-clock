<!DOCTYPE html>
<!--<html lang="cs" ng-app manifest="tea-clock.appcache">-->
<html lang="cs" ng-app="tea">
<head>
    <meta charset="utf-8">
    <title>Tea-clock</title>
    <meta name="description" content="">
    <meta name="author" content="">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Le HTML5 shim, for IE6-8 support of HTML elements -->
    <!--[if lt IE 9]>
    <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

    <!-- Le styles -->
    <link href="//netdna.bootstrapcdn.com/twitter-bootstrap/2.2.2/css/bootstrap-combined.min.css" rel="stylesheet">
    <link type="text/css" href="css/ui-lightness/jquery-ui-1.8.16.custom.css" rel="stylesheet"/>
    <link type="text/css" href="css/override.css" rel="stylesheet"/>

    <!-- Le fav and touch icons -->
    <link rel="shortcut icon" href="img/favicon.ico">
    <link rel="apple-touch-icon" href="img/favicon.ico">

    <!-- Place this render call where appropriate -->
    <script type="text/javascript">
        window.___gcfg = {lang: 'cs'};

        (function () {
            var po = document.createElement('script');
            po.type = 'text/javascript';
            po.async = true;
            po.src = 'https://apis.google.com/js/plusone.js';
            var s = document.getElementsByTagName('script')[0];
            s.parentNode.insertBefore(po, s);
        })();
    </script>


</head>

<body ng-controller="TimerController">
<div class="container">
    <div class="page-header">
        <h1>Tea-clock
            <small>Ať se louhuje...</small>
        </h1>
    </div>
    <div class="row">
        <div class="span12">
            <div class="alert alert-block alert-error" id="notification_not_found" hidden="hidden">
                <a class="close" data-dismiss="alert">×</a>
                <h4 class="alert-heading">Je vyžadován Chrome nebo Firefox!</h4>
                Tato aplikace potřebuje ke svému běhu <strong>desktopové notifikace</strong>, které aktuálně fungují pouze v
                <strong>Google Chrome</strong> nebo <strong>Google Chrome</strong>.
            </div>
        </div>
    </div>
    <div class="row">
        <div class="span12">
            <div class="alert alert-block alert-error" id="notification_disabled" hidden="hidden">
                <a class="close" data-dismiss="alert">×</a>
                <h4 class="alert-heading">Jsou vyžadovány notifikace!</h4>
                Tato aplikace opravdu potřebuje <strong>desktopové notifikace</strong>, povolte je, prosím!
            </div>
        </div>
    </div>

    <div class="row">
        <div class="span8">
            <div class="well">
                <form id="form1" class="form-horizontal">
                    <fieldset>
                        <legend>Jak pijete svůj čaj?</legend>
                            <label class="control-label">Druh čaje:</label>

                            <div class="control-group">
                                <div class="controls" ng-repeat="tea in teas">
                                    <label class='radio'>
                                        <input type='radio' ng-model='radio.index' value='{{$index}}'
                                               ng-checked="tea.checked" ng-change='updateDisplay()'/>{{tea.title}}
                                    </label>
                                </div>
                            </div>
                        <div class="control-group">
                            <label class="control-label" for="slider">Úprava času:</label>
                            <div class="controls">
                                <slider class="span4" id="slider"></slider>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">Supně:</label>
                            <div degrees class="btn-group controls" data-toggle="buttons-radio" model="model">{{model}}</div>
                        </div>                        
                    </fieldset>

                    <div class="form-actions">
                        <button class="btn btn-danger btn-large" type="button" ng-click="start()">
                            <i class="icon-time icon-white"></i>Louhuj</button>&nbsp;
                    </div>
                </form>
            </div>
        </div>

        <div class="span4" style="text-align:center">
            <div class="well">
                <div class="clearfix">
                    <img src="img/icon_pruhledna.png"><br/><br/>
                </div>
                <div class="clearfix">
                    <a href="#" class="btn btn-default btn-large" id="teaName">{{displayName}}</a><br/><br/>
                </div>
                <div class="clearfix">
                    <a href="#" class="btn btn-default btn-large" rel="tooltip"
                       title="Jak dlouho se bude čaj louhovat.">{{displayTime|time}}</a><br/><br/>
                </div>
                <div class="clearfix">
                    <a href="#" class="btn btn-default btn-large" rel="tooltip"
                       title="Při této teplotě by se měl vybraný čaj louhovat.">{{displayTemp}} °{{chosenDegree.symbol}}</a>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="span12">
            <p>
                <g:plusone annotation="inline"
                           href="https://chrome.google.com/webstore/detail/hmldmlgafdbnfhhicheojakimpmocggp"></g:plusone>
            </p>

        </div>
    </div>


    <footer>
        <!--           <p>&copy; lukas.marek (at) gmail.com, 2011</p> -->
        <script type="text/javascript">

            var _gaq = _gaq || [];
            _gaq.push(['_setAccount', 'UA-339099-9']);
            _gaq.push(['_trackPageview']);

            (function () {
                var ga = document.createElement('script');
                ga.type = 'text/javascript';
                ga.async = true;
                ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
                var s = document.getElementsByTagName('script')[0];
                s.parentNode.insertBefore(ga, s);
            })();

        </script>
    </footer>

    <a href="https://github.com/krtek/Tea-clock">
        <img style="position: absolute; z-index: 5; top: 0; right: 0; border: 0;"
             src="http://s3.amazonaws.com/github/ribbons/forkme_right_red_aa0000.png"
             alt="Fork me on GitHub"/>
    </a>


</div>
<!-- /container -->

<!-- modal(s) -->
<div class="modal hide fade" id="countdownModal" tabindex="-1" role="dialog" aria-labelledby="countdownLabel" aria-hidden="true">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h3>{{displayName}}</h3>
    </div>
    <div class="modal-body">
        <div style="text-align: center;"><h1>{{actualTime|time}}</h1></div>
        <div class="progress progress-striped active">
            <div class="bar" ng-style="{'width': actualTime / (time / 100) + '%'}" id="countdownBar"></div>
        </div>
    </div>
    <div class="modal-footer">
        <button class="btn btn-primary btn-large" ng-click="timer = false" data-dismiss="modal" aria-hidden="true" id="btn-reset"><i
                class="icon-repeat icon-white"></i>
            Reset
        </button>
    </div>
</div>

<!-- scripts -->

<script src="//ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
<script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.9.1/jquery-ui.min.js"></script>
<script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.0.4/angular.min.js"></script>

<script type="text/javascript" src="js/teas_cs.js"></script>
<script type="text/javascript" src="js/timer-ang.js"></script>


<script src="//netdna.bootstrapcdn.com/twitter-bootstrap/2.2.2/js/bootstrap.min.js"></script>
</body>
</html>
