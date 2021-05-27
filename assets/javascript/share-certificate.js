function click_handler(){
  copy_to_clipboard();
  change_text_and_icon_animation();
}

function copy_to_clipboard() {
  let input = document.body.appendChild(document.createElement("input"));
  input.value = window.location.href;
  input.select();
  document.execCommand("copy");
  input.parentNode.removeChild(input);
}

function change_text_and_icon_animation() {

  let text = document.getElementById('copyToClipboardButton');
  let original_text = text.innerHTML;

  text.innerHTML = `<span style="padding-top: 5px; padding-right: 5px; padding-bottom: 5px;">
        <img src="/images/check.svg">
        </span> Copied`;
  setTimeout(function() { text.innerHTML = original_text }, 5000);
}
