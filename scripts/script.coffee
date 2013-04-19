###
  tbaldw.in
  
  Music by Jon Hopkins (http://www.jonhopkins.co.uk) - Small Memory, Tunng Remix

  This documentation is helpful for the audio stuff:
  https://dvcs.w3.org/hg/audio/raw-file/tip/webaudio/specification.html

  Also: thanks to Justin Windle (soulwire.co.uk)
  This experiment was inspired by and built while referencing
  his codepen: http://codepen.io/soulwire/pen/Dscga

###

class VIZ

  constructor: (@el = document.body, @audio = new Audio(), @smoothing = 0.8, @fft = 2048) ->

    @mouse = x : 0, y : 0

    @AudioContext = self.AudioContext or self.webkitAudioContext
    @enabled = @AudioContext?

    return if /Safari/.test( navigator.userAgent ) and not /Chrome/.test( navigator.userAgent )

    if typeof @audio is 'string'
      src = @audio
      @audio = new Audio()
      @audio.controls = yes
      @audio.src = src

    @context = new @AudioContext();

    # lower numbers result in lower latency,
    # higher numbers help keep the audio from skipping or breaking up -
    # a problem which shows up with higher quality audio
    @jsNode = @context.createJavaScriptNode @fft

    @analyser = @context.createAnalyser();
    @analyser.smoothingTimeConstant = @smoothing; #default 0.8
    @analyser.fftSize = @fft #default 2048

    @data =
      bands : new Uint8Array @analyser.frequencyBinCount
      waveform : new Uint8Array @analyser.frequencyBinCount

    # get around this bug: http://crbug.com/112368
    @audio.addEventListener 'canplay', =>

      @el.appendChild @audio

      # reroutes the HTML audio element through the analyser
      @source = @context.createMediaElementSource @audio

      @source.connect @analyser
      @analyser.connect @jsNode

      @jsNode.connect @context.destination
      @source.connect @context.destination

      @audio.play()
      document.addEventListener "keyup", (e) =>
        if e.which is 32 #spacebar
          if @audio.paused
            @audio.play()
          else
            @audio.pause()

      @jsNode.onaudioprocess = =>

        @analyser.getByteFrequencyData @data.bands
        @analyser.getByteTimeDomainData @data.waveform

        @onUpdate?()
    
    warning = document.getElementById 'warning'
    warning.style.display = "none" if @enabled

    @setup3D()

  setup3D: ->

    width = @el.offsetWidth
    height = window.innerHeight
    aspect = width / height

    @dim = width: width, height: height, aspect: aspect

    @renderer = new THREE.WebGLRenderer
      antialias: true
    @renderer.setSize @dim.width, @dim.height
    @el.appendChild @renderer.domElement

    @scene = new THREE.Scene()
    @camera = new THREE.PerspectiveCamera 45, @dim.aspect, 1, 4000

    @camPos =
      x: 0
      y: 0
      z: 150

    @scene.add @camera
    @camera.position.set @camPos.x, @camPos.y, @camPos.z

    @light = new THREE.DirectionalLight 0xffffff, .9
    @light.position.set 0, 0, 150
    @scene.add @light

    #@scene.fog = new THREE.Fog 0xffffff, 1, 10000

    @bars = []

    #geometry = new THREE.CubeGeometry 1, 1, 1
    geometry = new THREE.SphereGeometry 1

    for i in [0...@analyser.frequencyBinCount - 50] by 1

      x = i * 0.4
      x = -x if i % 2 == 0

      material = new THREE.MeshPhongMaterial({ color: 0x69D2E7 })

      opts =
        material: material
        geometry: geometry
        id: i
        x: x
        y: 0
        z: 0

      bar = new Bar opts

      @scene.add bar.shape

      @bars.push bar

    @animate()
    window.onresize = @resizeWindow
    document.addEventListener "mousemove", @onMouseMove

  render: =>

    bar.render @ for bar in @bars

    @camera.position.x += ( @mouse.x / 3 - @camera.position.x ) * 0.03
    @camera.position.y += ( -@mouse.y / 3 - @camera.position.y ) * 0.03
    @camera.position.z = (abs @mouse.x / 10) + 120
    @camera.lookAt @scene.position
    @renderer.render @scene, @camera

  animate: =>
    requestAnimationFrame @animate
    @render()

  onMouseMove: (e) =>
    @mouse =
      x: e.clientX - @dim.width / 2
      y: e.clientY - @dim.height / 2

  resizeWindow: =>

    @dim.width = @el.offsetWidth
    @dim.height = window.innerHeight
    @dim.aspect = @dim.width / @dim.height

    @renderer.setSize @dim.width, @dim.height
    @camera.aspect = @dim.aspect


class Bar
  constructor: ( opts ) ->

    @id = opts.id

    @position = {}

    @position.x = opts.x or 0
    @position.y = opts.y or 0
    @position.z = opts.z or 0

    @shape = new THREE.Mesh opts.geometry, opts.material
    @shape.position.x = @position.x
    @shape.position.y = @position.y

    @shape.rotation.x = PI / 5
    @shape.rotation.y = PI / 5

  render: ( ctx ) ->
    data = ctx.data

    @position.y = max @position.y * 0.8, data.bands[@id] / 5

    @shape.position.y = @position.y

window.VIZ = VIZ