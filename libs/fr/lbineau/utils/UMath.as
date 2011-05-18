package fr.lbineau.utils
{
	import flash.geom.Point;

	public class UMath
	{
		/** The pre-calcuated value of Math.PI */
		public static var PI : Number = 3.141592653589793;
		/** The pre-calcuated value of (Math.PI/180) */
		public static var PI_OVER_180 : Number = 0.017453292519943295;

		public function UMath()
		{
			throw new Error("MathUtils is a static class and should not be instantiated");
		}

		public static function deg2rad(n : Number) : Number
		{
			return n * PI / 180;
		}

		public static function rad2deg(n : Number) : Number
		{
			return n * 180 / PI;
		}

		public static function getLineEquation(p0 : Point, p1 : Point) : Object
		{
			var a : Number = (p1.y - p0.y) / (p1.x - p0.x);
			var b : Number = p0.y - a * p0.x;

			return {a:a, b:b};
		}

		public static function boundaryRestrict(n : Number, min : Number, max : Number) : Number
		{
			n = n < min ? min : n;
			n = n > max ? max : n;

			return n;
		}

		/**
		 * Determines whether or not the supplied number is positive
		 * @param _num 	The number to evaluate
		 * @return Whether or not the supplied number is positive
		 */
		public static function isPositive(_num : Number) : Boolean
		{
			return(_num >= 0) as Boolean;
		}

		/**
		 * Determines whether or not the supplied number is negative
		 * @param _num 	The number to evaluate
		 * @return Whether or not the supplied number is negative
		 */
		public static function isNegative(_num : Number) : Boolean
		{
			return !isPositive(_num);
		}

		/**
		 * Determines whether or not the supplied number is even
		 * @param _num	The number to evaluated
		 * @return 		True if _num is an even number
		 */
		public static function isEven(_num : Number) : Boolean
		{
			return ((_num % 2) == 0);
		}

		/**
		 * Determines whether or not the supplied number is odd
		 * @param _num	The number to evaluated
		 * @return 		True if _num is an odd number
		 */
		public static function isOdd(_num : Number) : Boolean
		{
			return !isEven(_num);
		}

		/**
		 * Determines whether or not the supplied number is a whole number
		 * @param _num	The number to be evaluated
		 * @return 		True if _num is a whole number
		 */
		public static function isWholeNumber(_num : Number) : Boolean
		{
			return (Math.floor(_num) == _num);
		}

		/**
		 * Determines whether or not the supplied number is a decimal
		 * @param _num	The number to be evaluated
		 * @return 		True if _num is a decimal
		 * @example
		 * <code>
		 * trace(MathUtils.isDecimalNumber(1.1)); // true
		 * trace(MathUtils.isDecimalNumber(0.3)); // true
		 * trace(MathUtils.isDecimalNumber(5)); // false
		 * </code>
		 */
		public static function isDecimalNumber(_num : Number) : Boolean
		{
			return !isWholeNumber(_num);
		}

		/**
		 * Determines whether or not the supplied number is a prime number. NOTE only natural numbers are evaluated, decimal and negative numbers are not considered prime numbers even if they have more than two divisors.
		 * @param _num	The number to be evalulated
		 * @return 		True if _num is a prime number
		 * @see <a href="http://en.wikipedia.org/wiki/Prime_number" target="_blank" alt="Prime Numbers">Prime Numbers</a>
		 * @see <a href="http://en.wikipedia.org/wiki/Natural_number" target="_blank" alt="Natural Numbers">Natural Numbers</a>
		 */
		public static function isPrimeNumber(_num : Number) : Boolean
		{
			_num = abs(_num);
			if (_num == 1) return true;
			if (isEven(_num) || isNegative(_num)) return false;
			for (var i : int = 2; i < _num; i++)
			{
				if (isWholeNumber(_num / i)) return false;
			}
			return true;
		}

		/**
		 * Returns an {@code Array} of even numbers within the supplied range
		 * @param _min	The minimum range, if a decimal is passed the floor is used
		 * @param _max	The maximum range, if a decimal is passed the floor is used
		 * @return 		{@code Array} of even numbers within the supplied range
		 */
		public static function getEvenNumbersWithinRange(_min : int, _max : int) : Array
		{
			var _int : int = 0;
			if (isEven(_min)) _int = 1;
			var _evens : Array = new Array();
			for (var i : int = _min; i <= _max; i++)
			{
				if (_int == 1) _evens.push(i);
				_int = abs(_int - 1);
			}
			return _evens;
		}

		/**
		 * Returns an {@code Array} of odd numbers within the supplied range
		 * @param _min	The minimum range, if a decimal is passed the floor is used
		 * @param _max	The maximum range, if a decimal is passed the floor is used
		 * @return 		{@code Array} of odd numbers within the supplied range
		 */
		public static function getOddNumbersWithinRange(_min : int, _max : int) : Array
		{
			var _int : int = 0;
			if (isOdd(_min)) _int = 1;
			var _odds : Array = new Array();
			for (var i : int = _min; i <= _max; i++)
			{
				if (_int == 1) _odds.push(i);
				_int = abs(_int - 1);
			}
			return _odds;
		}

		/**
		 * Returns an {@code Array} of prime numbers within the supplied range
		 * @param _min	The minimum range, if a decimal is passed the floor is used
		 * @param _max	The maximum range, if a decimal is passed the floor is used
		 * @return 		{@code Array} of primes within the supplied range
		 */
		public static function getPrimeNumbersWithinRange(_min : int, _max : int) : Array
		{
			var _primes : Array = new Array();
			for (var i : int = _min; i <= _max; i++)
			{
				if (isPrimeNumber(i)) _primes.push(i);
			}
			return _primes;
		}

		/**
		 * Converts the supplied degrees to radians
		 * @param _degrees	The degrees to be converted to radians
		 * @return 			The supplied degrees converted to radians
		 */
		public static function degreesToRadians(_degrees : Number) : Number
		{
			return _degrees * PI_OVER_180;
		}

		/**
		 * Converts the supplied radians represented as degrees
		 * @param _radians	The radians to be converted to degrees
		 * @return 			The radians converted to degrees
		 */
		public static function radiansToDegrees(_radians : Number) : Number
		{
			return _radians / PI_OVER_180;
		}

		/**
		 * Simplifys the supplied angle to its simpliest representation
		 * @param _angle	The angle to simplify
		 * @return 		The supplied angle simplified
		 * @example
		 * <code>
		 * var _simpAngle:Number = MathUtils.simplifyAngle(725); // returns 5
		 * var _simpAngle2:Number = MathUtils.simplifyAngle(-725); // returns -5
		 * </code>
		 */
		public static function simplifyAngle(_angle : Number) : Number
		{
			var _rotations : Number = Math.floor(_angle / 360);
			return (_angle >= 0) ? _angle - (360 * _rotations) : _angle + (360 * _rotations);
		}

		/**
		 * Rounds the supplied number to the requested decimal precission
		 * @param _num		The number to round
		 * @param _decPrec	The decimal precission to round to
		 * @return 			The supplied number rounded to the supplied decimal precission
		 * @example
		 * <code>
		 * var _decRound:Number = MathUtils.roundDecimalPrecission(3.141592653589793, 4); // returns 3.1415;
		 * </code>
		 */
		public static function roundDecimalPrecission(_num : Number, _decPrec : Number = 2) : Number
		{
			var _powAmount : Number = (Math.pow(10, _decPrec));
			var _wholeNum : Number = _num * _powAmount;
			_wholeNum = round(_wholeNum);
			_num = _wholeNum / _powAmount;
			return _num;
		}

		/**
		 *	Determines and returns which interval distance the value is closer to
		 *	@param _value	The value to evaluate
		 *	@param _dist	The interval distance
		 *	@return Which evenly divisble distance the value is closer to
		 *	@example
		 *	<code>
		 *	MathUtils.magneticModulo(23, 10); // returns 20
		 *	MathUtils.magneticModulo(27, 10); // returns 30
		 *	</code>
		 */
		public static function magneticModulo(_value : Number, _dist : Number) : Number
		{
			var _rem : Number = _value % _dist;
			(_rem < (_dist * 0.5)) ? _value -= _rem : _value += _dist - _rem;
			return _value;
		}

		/** 
		 * Generates and returns a truely unique (not random) integer casted as a {@code Number}. 
		 * int.MAX_VALUE is the largest representable 32-bit signed integer, which is 2,147,483,647 ((2^31) - 1)
		 * Casting the return value as an int will result in an incorrect value, because its such a large number
		 * @return A unique integer, creates a new Date instance and returns its time property
		 * @see <a href="http://livedocs.adobe.com/flash/9.0/ActionScriptLangRefV3/Date.html#time" target="_blank" alt="Date.time">Date.time</a>
		 * @example
		 * <code>
		 * var _n:Number = MathUtils.generateUniqueInt(); // correct value, 1230707045775
		 * var _i:int = _n; // incorrect value, -1948568177
		 * </code>
		 */
		public static function generateTruelyUniqueInt() : Number
		{
			return new Date().time;
		}

		/**
		 * Returns a random number between min and max
		 * @param min	The minimum range
		 * @param max	The maximum range
		 * @return		A random number between min and max
		 */
		public static function randomRange(min : Number, max : Number) : Number
		{
			return min + _random(max - min);
		}

		private static function _random(n : Number) : Number
		{
			return (Math.random() * n);
		}

		public static function round(n : Number) : int
		{
			return int(n + .5);
		}

		public static function abs(n : Number) : Number
		{
			if (n < 0) return -n;
			return n;
		}
	}
}