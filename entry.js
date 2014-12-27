function submit(event, box)
{
  var name = document.getElementById("name");

  var wintag = document.getElementById("iscorrect");
  wintag.style.color = "yellow";
  wintag.innerHTML = "LOADING...";

  var xhr = new XMLHttpRequest();
  xhr.open("GET", "/flags/" + name.innerHTML + "/" + box.value, false);
  xhr.send();

  if (xhr.responseText == "Yay\n") {
    wintag.innerHTML = "WOOT!";
    wintag.style.color = "green";
  } else if (xhr.responseText == "Keep going\n") {
    wintag.innerHTML = "KEEP GOING";
    wintag.style.color = "purple";
  } else {
    wintag.innerHTML = "NOPE";
    wintag.style.color = "red";
  }
}

function keyup(event, box)
{
  if (event.keyCode == 13) {
    submit(event, box);
    return
  }

  if (new RegExp("^[-_a-zA-Z0-9]{1,32}$").exec(box.value) == null) {
    box.style.borderColor = "red";
    return;
  }

  box.style = null;
  document.getElementById("name").innerHTML = document.getElementById("team").value;
}
