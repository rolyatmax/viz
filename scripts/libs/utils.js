(function(){

	// Mixed into the window object
	var globals = {

	    PI         : Math.PI,
	    TWO_PI     : Math.PI * 2,
	    HALF_PI    : Math.PI / 2,
	    QUARTER_PI : Math.PI / 4,

	    abs        : Math.abs,
	    acos       : Math.acos,
	    asin       : Math.asin,
	    atan2      : Math.atan2,
	    atan       : Math.atan,
	    ceil       : Math.ceil,
	    cos        : Math.cos,
	    exp        : Math.exp,
	    floor      : Math.floor,
	    log        : Math.log,
	    max        : Math.max,
	    min        : Math.min,
	    pow        : Math.pow,
	    round      : Math.round,
	    sin        : Math.sin,
	    sqrt       : Math.sqrt,
	    tan        : Math.tan,

	    // TODO: map, lerp (etc)

	    random     : function( min, max ) {

	        if ( min && typeof min.length === 'number' && !!min.length )
	            return min[ Math.floor( Math.random() * min.length ) ];

	        if ( typeof max !== 'number' )
	            max = min || 1, min = 0;

	        return min + Math.random() * (max - min);
	    }
	};

	// Soft object merge
	function extend( target, source ) {

	    for ( var prop in source ) {

	        if ( !target.hasOwnProperty( prop ) ) {
	            target[ prop ] = source[ prop ];
	        }
	    }

	    return target;
	}

	extend(this, globals);

}());