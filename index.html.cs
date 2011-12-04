<!DOCTYPE html>
<html lang="en">
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
    <link href="css/bootstrap.css" rel="stylesheet">
    <link type="text/css" href="css/ui-lightness/jquery-ui-1.8.16.custom.css" rel="stylesheet" />
	<link href="css/override.css" rel="stylesheet"/>	

    <!-- Le fav and touch icons -->
    <link rel="shortcut icon" href="images/favicon.ico">
    <link rel="apple-touch-icon" href="images/apple-touch-icon.png">
    <link rel="apple-touch-icon" sizes="72x72" href="images/apple-touch-icon-72x72.png">
    <link rel="apple-touch-icon" sizes="114x114" href="images/apple-touch-icon-114x114.png">
		
	<script type="text/javascript" src="js/jquery-1.6.2.min.js"></script>
	<script type="text/javascript" src="js/jquery-ui-1.8.16.custom.min.js"></script>
    
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
          <div class="span8">
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
		  <div class="span4">
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
      </footer>

    </div> <!-- /container -->

  </body>
</html>
