$(document).ready(function() {
	$('textarea#activityFeedStatus').keypress(function (e) {  
	       if(e.which == 13)   {   
	       var control = e.target;                     
	       var controlHeight = $(control).height();          
	      //add some height to existing height of control, I chose 17 as my line-height was 17 for the control    
	    $(control).height(controlHeight+17);  
	    }
	    }); 

	$('textarea#activityFeedStatus').blur(function (e) {         
	    var textLines = $(this).val().trim().split(/\r*\n/).length;  
	    $(this).val($(this).val().trim()).height(textLines*17);
	    });

	$(document).on('click', '#showComments', function(event) {
		event.preventDefault();
		$('#' + $(this).data('commentId')).toggle();
	});
});