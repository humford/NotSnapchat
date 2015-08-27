function openSnap(element) {
  $.get("/open/" + $(element).parent().parent().attr("snapid"), function(data){
      data = JSON.parse(data)
      img = $(element).parent().append("<img src="+data.imgPath+"></img>")
      setTimeout(function(){
	  	$(img).parent().fadeOut(250, function(){
			$(img).parent().remove()
		})
        $.get("/close"+$(element).parent().parent().attr("snapid"))
      },8000)

  })
}
