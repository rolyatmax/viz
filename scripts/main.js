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

    var viz = window.viz = new VIZ(el, MP3_PATH, SMOOTHING, FFT);


  });

});