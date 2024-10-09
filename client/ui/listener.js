$(document).keydown(function (e) // Disable Tab Key
{
    var keycode1 = (e.keyCode ? e.keyCode : e.which);
    if (keycode1 == 0 || keycode1 == 9) {
        e.preventDefault();
        e.stopPropagation();
    }
});

$(function(){
	window.addEventListener('message', function(event) {
		var item = event.data;
		if (item.type === "ui"){
			if (item.status) {
				$(".seconds").text("Waiting for players.");
				$(".container").fadeIn();		
			} else { 
				$(".container").fadeOut();
			}
		}

		if (item.type === "arenaName"){
			$(".arenaName").html(item.arenaName);
			let map = item.arenaName.match(/\(([^)]+)\)/);
			if(map!=null){
				$(".map").fadeIn();
				$(".map").attr("src","nui://ArenaLobby/client/ui/img/games/map/"+map[1]+".jpg");
				$(".map").error(function () {
					$(this).hide();
				});
			}else{
				$(".map").hide();
			}
		}
		
		if (item.type === "arenaImage"){
			$(".banner").attr("src","nui://ArenaLobby/client/ui/img/games/"+item.arenaImage+".jpg");
		}
		
		if (item.type === "arenaImageURL"){
			$(".banner").attr("src",item.arenaImage);
		}
		
		if (item.type === "updateTime"){
			$(".seconds").text("Game will start in: "+ item.time +" second.");
		}else if (item.type !== "playerNameList"){
			$(".seconds").text("Waiting for players.");
		}
		
		if (item.type === "playerNameList"){
			$(".players").text("");
            for (var index in item.Names) {
			    $(".players").append("<div class='col-3 mb-4'><img class='avatar' src='"+item.Names[index].avatar+"'> " + item.Names[index].name + "</div>")
			}
			$(".playerCount").text(item.Names.length)
		}
	})
});