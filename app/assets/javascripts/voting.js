$(document).ready(function(e){
	
  var neg_count = -1
  var pos_count = 1

  // When somen clicks on a thumb, the vote counter in that same div will increment
  $('.thumbs-down').click(function(e){
	var $parent_div = $(this).parent();
	var $counter = $parent_div.children().first();
	$counter.html(neg_count)
	neg_count --;
  });

  $('.thumbs-up').click(function(e){	
	var $parent_div = $(this).parent();
	var $counter = $parent_div.children().first();
	$counter.html(pos_count)
	pos_count ++;
  });

});