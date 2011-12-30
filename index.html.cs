<!DOCTYPE html>
<html lang="cs" manifest="tea-clock.appcache">
  <head>
    <meta charset="utf-8">
    <title>Tea-clock</title>
    <meta name="description" content="">
    <meta name="author" content="">

    <!-- Le HTML5 shim, for IE6-8 support of HTML elements -->
    <!--[if lt IE 9]>
      <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->

    <!-- Le styles -->
    <link rel="stylesheet" href="http://twitter.github.com/bootstrap/1.4.0/bootstrap.min.css">
    <link type="text/css" href="css/ui-lightness/jquery-ui-1.8.16.custom.css" rel="stylesheet" />
	<link href="css/override.css" rel="stylesheet"/>	

    <!-- Le fav and touch icons -->
    <link rel="shortcut icon" href="images/favicon.ico">
    <link rel="apple-touch-icon" href="images/apple-touch-icon.png">
    <link rel="apple-touch-icon" sizes="72x72" href="images/apple-touch-icon-72x72.png">
    <link rel="apple-touch-icon" sizes="114x114" href="images/apple-touch-icon-114x114.png">
		
	<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
	<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.min.js"></script>
    
    <script type="text/javascript" src="js/timer.js"></script>
    <script type="text/javascript" src="js/teas_cs.js"></script>
    <script type="text/javascript" src="js/bootstrap-buttons.js"></script>
    <script type="text/javascript" src="js/bootstrap-twipsy.js"></script>
    <script type="text/javascript" src="js/bootstrap-popover.js"></script>

<!-- Place this render call where appropriate -->
	<script type="text/javascript">
	window.___gcfg = {lang: 'cs'};
	
  	(function() {
    		var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
    		po.src = 'https://apis.google.com/js/plusone.js';
    		var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
	  })();
	</script>


  </head>

  <body>
    <div class="container">                    

      <div class="content">
        <div class="page-header">
          <h1>Tea-clock <small>Ať se louhuje...</small></h1>
        </div>
		<div class="row">
			<div class="span12">
				<div class="alert-message error" hidden="true">
				  <p><strong>Je vyžadován Chrome!</strong><br/>Tato aplikace potřebuje ke svému běhu <strong>desktopové notifikace</strong>, které aktuálně fungují pouze v <strong>Google Chrome.</strong></p>
				</div>
			</div>
		</div>
        <div class="row">
          <div class="span9">
			<div class="well">
	            <form id="form1">
					<fieldset>
		              	<div class="clearfix">   
	                		<label id="optionsTime">Druh čaje:</label>
	                		<div class="input">          
	                  			<ul class="inputs-list" id="radios"></ul>
	                		</div>
	
						</div>
		              	<div class="clearfix">   
							<label id="exactTime">Úprava času:</label>
							<div class="span3 input" id="slider"></div>
						</div>
	              	</fieldset>
					
	              <div class="actions">
	                <button id="btn-run" data-loading-text="Louhuju" class="btn danger large">Louhuj</button>&nbsp;
	                <button class="btn primary large">Reset</button>
	              </div>
	            </form>
	            <p><g:plusone annotation="inline" href="https://chrome.google.com/webstore/detail/hmldmlgafdbnfhhicheojakimpmocggp"></g:plusone></p>
			</div>
          </div>
		  <div class="span4" style="text-align:center">
			<div class="well">
				<div class="clearfix">
					<img src="img/icon_pruhledna.png"><br/><br/>
				</div>
				<div class="clearfix">
					<a href="#" class="btn default large" id="teaName"></a><br/><br/>
				</div>
				<div class="clearfix">
					<a href="#" class="btn default large" rel="popover" id="teaTime" data-content="Jak dlouho se bude čaj louhovat." data-original-title="Čas">1:00</a><br/><br/>
				</div>
				<div class="clearfix">
					<a href="#" class="btn default large" rel="popover" id="teaTemp" data-content="Při této teplotě by se měl vybraný čaj louhovat." data-original-title="Teplota">60C</a>
				</div>
				
			</div>
		  </div>	

        </div>
      </div>

      <footer>
           <p>&copy; lukas.marek (at) gmail.com, 2011</p>
	  	<script type="text/javascript">

			  var _gaq = _gaq || [];
			  _gaq.push(['_setAccount', 'UA-339099-9']);
			  _gaq.push(['_trackPageview']);

			  (function() {
    			var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
			    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
			    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
			  })();

		</script>
      </footer>

<a href="https://github.com/krtek/Tea-clock">
	<img style="position: absolute; z-index: 5; top: 0; right: 0; border: 0;"
		 src="http://s3.amazonaws.com/github/ribbons/forkme_right_red_aa0000.png"
		 alt="Fork me on GitHub" />
</a>


    </div> <!-- /container -->

  </body>
</html>
