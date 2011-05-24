/**
* This is about <code>org.shoebox.collections.QuadTree</code>.
* {@link www.hyperfiction.fr}
* @author shoe[box]
*/

package org.shoebox.collections {

	import org.shoebox.utils.logger.Logger;
	import flash.geom.Rectangle;
	
	/**
	* org.shoebox.collections.QuadTree
	* @author shoebox
	*/
	public class QuadTree {
		
		protected var _oRoot				: QuadTreeNode;
		protected var _vContent			: Vector.<*>;
		protected var _vRes				: Vector.<*>;
		
		internal var i : int , l : int , vRes : Vector.<*>;
		internal var itemId				: int;
		internal var vTmp				: Vector.<int>;
		
		// -------o constructor
		
			/**
			* Constructor of the QuadTree class
			*
			* @public
			* @return	void
			*/
			public function QuadTree( rec : Rectangle , iLevels : uint = 5 ) : void {
				
				vRes = new Vector.<*>( );
				vTmp = new Vector.<int>( );
				_oRoot = new QuadTreeNode( rec , null , 0 , iLevels );
				_vContent = new Vector.<*>( );
			}

		// -------o public
			
			/**
			* addItem function
			* @public
			* @param 
			* @return
			*/
			final public function addItemAt( o : * , rBounds : Rectangle ) : void {
				
				itemId = _getHash( o );
				if( itemId == -1 ) 
					itemId = _vContent.push( o ) - 1;
				
				_oRoot.addItemAt( itemId , rBounds.clone( ) );
				
			}
			
			/**
			* getRect function
			* @public
			* @param 
			* @return
			*/
			final public function getRectContent( r : Rectangle ) : Vector.<*> {
				
				
				//
					vTmp.splice( 0 , vTmp.length );
					vRes.splice( 0 , vRes.length );
					_oRoot.getRectContent( r , vTmp );
				
				//
					i = 0;
					l = vTmp.length;
					for( i ; i < l ; i++ ) 
						vRes.push( _vContent[ vTmp[i]]);
				
				return vRes;
			}
			
			/**
			* getRectContentByKey function
			* @public
			* @param 
			* @return
			*/
			final public function getRectContentByKey( r : Rectangle ) : Vector.<int> {
				
				//
					vTmp.splice( 0 , vTmp.length );
					_oRoot.getRectContent( r , vTmp );
					
				return vTmp;
				
			}
			
			/**
			* getValue function
			* @public
			* @param 
			* @return
			*/
			final public function getValue( i : int ) : * {
				return _vContent[ i ];
			}
			
		// -------o protected
			
			/**
			* 
			*
			* @param 
			* @return
			*/
			final protected function _getHash( o : * ) : int {
				return _vContent.indexOf( o );
			}
			
		// -------o misc

			public static function trc(...args : *) : void {
				Logger.log(QuadTree, args);
			}
	}
}
