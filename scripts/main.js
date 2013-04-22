require([
  'libs/Markdown.Converter',
  'libs/jquery-1.9.1.min',
  'scripts/libs/Three.js',
  'libs/utils',
  'info',
  'script'
  ], function() {

  var opts = {
    textURL: "README.md",
    keyTrigger: true
  };

  var info = new Info( opts );

  $(function() {

    var warning = document.getElementById('warning');
    warning.style.display = 'block';

    var SMOOTHING = 0.9;
    var FFT = 512;
    var MP3_PATH = 'audio/small_memory_tunng.mp3';
    var el = document.getElementById('container');

    var COLORS = [0x69D2E7, 0xBEFAF6, 0x9D91EB, 0xB6D4CD, 0x435B9C];
    var COLORS2 = [0x74ECFF, 0x14717F, 0x28E3FF, 0x3A767F, 0x20B6CC];
    var COLORS3 = [0xACB3FF, 0x7C7D7F, 0xF9FBFF, 0x56647F, 0xC7C9CC];

    var COLORSET = random([COLORS, COLORS2, COLORS3]);

    var viz = window.viz = new VIZ(el, MP3_PATH, SMOOTHING, FFT, COLORSET);


  });

});