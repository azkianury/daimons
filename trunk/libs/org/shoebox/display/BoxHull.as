/**
* This is about <code>org.shoebox.display.BoxHull</code>.
* {@link www.hyperfiction.fr}
* @author shoe[box]
*/

package org.shoebox.display {

	import org.shoebox.utils.logger.Logger;
	import flash.geom.Point;
	
	/**
	* org.shoebox.display.BoxHull
	* @author shoebox
	*/
	public class BoxHull {
		
		protected var _uDist			: uint;
		protected var _uLength			: uint;
		protected var _aBlobs			: Array;
		protected var _vPoints			: Vector.<Point>;
		protected var _aBlobsIds		: Array;
		
		// -------o constructor
		
			/**
			* Constructor of the BoxHull class
			*
			* @public
			* @return	void
			*/
			public function BoxHull(  ) : void {
				
			}

		// -------o public
			
			/**
			* blobs function
			* @public
			* @param 
			* @return
			*/
			final public function blobs( v : Vector.<Point> , d : uint = 30 ) : Vector.<Vector.<Point>> {
				_aBlobsIds = [ ];
				_aBlobs = [ ];
				_uLength = v.length;
				_vPoints = v;
				_uDist = d;
				return _blobs( );
			}
			
			/**
			* hullCompute function
			* @public
			* @param 
			* @return
			*/
			static public function computeHull( p : Vector.<Point> ) : Array {
				
				var len : uint = p.length;
				
				// check arguments
				if (len < 3)
					throw new ArgumentError('Input must have at least 3 points');
	
				var pts : Array = new Array(len - 1);
				var stack : Array = new Array(len);
				var i : uint, j : uint, i0 : uint = 0;
	
				// find the starting ref point: leftmost point with the minimum y coord
				for (i = 0; i < len; ++i) {
					if (p[i].y < p[i0].y) {
						i0 = i;
					} else if (p[i].y == p[i0].y) {
						i0 = (p[i].x < p[i0].x ? i : i0);
					}
				}
	
				// calculate polar angles from ref point and sort
				for (i = 0, j = 0; i < len; ++i) {
					if (i != i0) {
						pts[j++] = {angle:Math.atan2(p[i].y - p[i0].y, p[i].x - p[i0].x), index:i};
					}
				}
				pts.sortOn('angle');
	
				// toss out duplicated angles
				var angle : Number = pts[0].angle;
				var ti : uint = 0, tj : uint = pts[0].index;
				for (i = 1; i < len - 1; i++) {
					j = pts[i].index;
					if (angle == pts[i].angle) {
						// keep angle corresponding to point most distant from reference point
						var d1 : Number = Point.distance(p[i0], p[tj]);
						var d2 : Number = Point.distance(p[i0], p[j]);
	
						if (d1 >= d2) {
							pts[i].index = -1;
						} else {
							pts[ti].index = -1;
							angle = pts[i].angle;
							ti = i;
							tj = j;
						}
					} else {
						angle = pts[i].angle;
						ti = i;
						tj = j;
					}
				}
	
				// initialize the stack
				var sp : uint = 0;
				stack[sp++] = i0;
				var h : uint = 0;
				for (var k : uint = 0; k < 2; h++) {
					if (pts[h].index != -1) {
						stack[sp++] = pts[h].index;
						k++;
					}
				}
	
				// do graham's scan
				for (; h < len - 1; h++) {
					if (pts[h].index == -1) continue;
					// skip tossed out points
					while (_isNonLeft(i0, stack[sp - 2], stack[sp - 1], pts[h].index, p))
						sp--;
					stack[sp++] = pts[h].index;
				}
	
				// construct the hull
				var hull : Array = new Array(sp);
				for (i = 0; i < sp; ++i) {
					hull[i] = p[stack[i]];
				}
				return hull;
			}
			
		// -------o protected
			
			/**
			* 
			*
			* @param 
			* @return
			*/
			static protected function _isNonLeft( i0:uint, i1:uint, i2:uint, i3:uint, p:Vector.<Point> ) : Boolean {
				var l1:Number, l2:Number, l4:Number, l5:Number, l6:Number, a:Number, b:Number;

		            a = p[i2].y - p[i1].y; b = p[i2].x - p[i1].y; l1 = Math.sqrt(a * a + b * b);
		            a = p[i3].y - p[i2].y; b = p[i3].x - p[i2].y; l2 = Math.sqrt(a * a + b * b);
		            a = p[i3].y - p[i0].y; b = p[i3].x - p[i0].y; l4 = Math.sqrt(a * a + b * b);
		            a = p[i1].y - p[i0].y; b = p[i1].x - p[i0].y; l5 = Math.sqrt(a * a + b * b);
		            a = p[i2].y - p[i0].y; b = p[i2].x - p[i0].y; l6 = Math.sqrt(a * a + b * b);
		            
		            a = Math.acos((l2*l2 + l6*l6 - l4*l4) / (2*l2*l6));
		            b = Math.acos((l6*l6 + l1*l1 - l5*l5) / (2*l6*l1));
		
		            return (Math.PI - a - b < 0);
			}
			
			/**
			* 
			*
			* @param 
			* @return
			*/
			final protected function _blobs( ) : Vector.<Vector.<Point>> {
				
				var i:int;
				var j:int;
				
				_bloby(0, 0);
				
				i = 1;
				
				var dx : int, dy : int , d : int , b : Boolean = false , iBlob : int = -1, iNear : int , k : int; 
				
				while(i < _uLength ) {
					b = false;
					iBlob = -1;
					j = 0;
					
					while( j < i ){
						
						dx = _vPoints[j].x - _vPoints[i].x;
						dy = _vPoints[j].y - _vPoints[i].y;
						d = Math.sqrt(dx*dx + dy*dy);
						
						if ( d < _uDist ){
							b = true;
							
							if (iBlob == -1 ){
								
								iBlob = _aBlobsIds[j];
								_bloby(i, _aBlobsIds[j]);
								
							} else {
								
								iNear = _aBlobsIds[j];
								if ( iNear != iBlob){
									k = 0;
									do {
										if (_aBlobsIds[k] == iNear ) 
											_bloby( k, iBlob);
											
										k++;
										
									} while (k<_aBlobsIds.length);
									
									_aBlobs[iNear].clear( );
								}
							}
						}
						j++;
					}
					
					if (!b) 
						_bloby(i, _aBlobs.length);
					
					i++;
				};
				
				
				var blob : Blob;
				var vRes : Vector.<Vector.<Point>> = new Vector.<Vector.<Point>>( );
				for each( blob in _aBlobs ){
					if( blob.vPoints.length > 0 )
						vRes.push( blob.vPoints );
					
				}
				
				
				return vRes;
				
			}
			
			/**
			* 
			*
			* @param 
			* @return
			*/
			final protected function _bloby( n : int , id : int ) : void {
				
				if( !_aBlobs[ id ] )
					_aBlobs[ id ] = new Blob( id );
					_aBlobs[ id ].add( _vPoints[n] ); 
				
				_aBlobsIds[n] = id;
				
			}
			
		// -------o misc

			public static function trc(...args : *) : void {
				Logger.log(BoxHull, args);
			}
	}
}

import flash.geom.Point;
internal class Blob{
	
	public var id 			: int;
	public var vPoints		: Vector.<Point> = new Vector.<Point>( );
	
	
	/**
	* Blob function
	* @public
	* @param 
	* @return
	*/
	final public function Blob( id : int ) : void {
		this.id = id;
	}
	
	/**
	* addPoint function
	* @public
	* @param 
	* @return
	*/
	final public function add( p : Point ) : void {
		vPoints.push( p );
	}
	
	/**
	* clear function
	* @public
	* @param 
	* @return
	*/
	final public function clear() : void {
		vPoints = new Vector.<Point>( );
	}
	
}
