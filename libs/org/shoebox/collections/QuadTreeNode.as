/**
  HomeMade by shoe[box]
 
  Redistribution and use in source and binary forms, with or without 
  modification, are permitted provided that the following conditions are
  met:

  * Redistributions of source code must retain the above copyright notice, 
    this list of conditions and the following disclaimer.
  
  * Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in the 
    documentation and/or other materials provided with the distribution.
  
  * Neither the name of shoe[box] nor the names of its 
    contributors may be used to endorse or promote products derived from 
    this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
  IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

package org.shoebox.collections {
	import org.shoebox.core.BoxRectangle;
	import org.shoebox.utils.logger.Logger;

	import flash.geom.Rectangle;

	/**
	 * org.shoebox.collections.QuadTreeNode
	* @author shoebox
	*/
	public class QuadTreeNode {
		
		protected var _bInitialized			: Boolean = false;
		protected var _bHasContent			: Boolean = false;
		protected var _bHasChilds			: Boolean = true;
		protected var _bHasActiveChilds		: Boolean = false;
		protected var _oParentNode			: QuadTreeNode;
		protected var _oQuadRec			: Rectangle;
		protected var _iDepth				: int;
		protected var _iDepthMax			: int;
		protected var _vChildrens			: Vector.<QuadTreeNode>;
		protected var _vItems				: Vector.<QuadTreeContent>;
		
		protected const CHILDS_LEN			: int = 4;
		
		internal var i 					: int = 0;
		internal var l 					: int = 0;
		internal var bRes				: Boolean;
		internal var child				: QuadTreeNode;
		internal var entry				: QuadTreeContent;
		
		// -------o constructor
		
			/**
			* Constructor of the QuadTreeNode class
			*
			* @public
			* @return	void
			*/
			public function QuadTreeNode( rec : Rectangle , parent : QuadTreeNode = null , d : uint = 0 , max : uint = 10) : void {
				
				if( rec == null)
					Logger.warn( this , 'The bounding rec cannot be null' );
				
				_oQuadRec = rec;
				_oParentNode = parent;
				_iDepth = d;
				_iDepthMax = max;
			}

		// -------o public
			
			/**
			* addItemAt function
			* @public
			* @param 
			* @return
			*/
			public function addItemAt( o : * , r : Rectangle ) : Boolean {
				
				if( !_bInitialized )
					_init( );
					
				if(_oQuadRec.containsRect( r )){
					
					if(r.width <= _oQuadRec.width && r.height <= _oQuadRec.height ){
					
						if( _bHasChilds ){
							
							i = 0;
							bRes = false;
							for( i ; i < CHILDS_LEN ; i++ ){
								
								bRes = _vChildrens[ i ].addItemAt( o , r );
								if( bRes )
									break;
								
							}
						
							if( !bRes )
								insertItem( o , r);
							else
								_bHasActiveChilds = true;
						}
						
					}else
						insertItem( o , r);
					
				}else
					insertItem( o , r );
				
				return false;
			
			}
			
			/**
			* get rect function
			* @public
			* @param 
			* @return
			*/
			public function get rect() : Rectangle {
				return _oQuadRec;
			}

			/**
			* insertItem function
			* @public
			* @param 
			* @return
			*/
			public function insertItem( u : uint , r : Rectangle ) : void {
				
				if( !_vItems )
					_vItems = new Vector.<QuadTreeContent>();
					_vItems.push( new QuadTreeContent( u , r ) );
					
				_bHasContent = true;
			}
			
			/**
			* get hasChilds function
			* @public
			* @param 
			* @return
			*/
			public function get hasChilds() : Boolean {
				return _bHasChilds;
			}
			
			/**
			* get activeChilds function
			* @public
			* @param 
			* @return
			*/
			public function get activeChilds() : Boolean {
				return _bHasActiveChilds;
			}
			
			/**
			* getRectContent function
			* @public
			* @param 
			* @return
			*/
			public function getRectContent( r : Rectangle , vRes : Vector.<int> ) : void {
				
				if( _oQuadRec.intersects( r )){
					
					if( _bHasContent ){
						
						i = 0;
						l = _vItems.length;
						for( i ; i < l ; i++ ){
							entry = _vItems[i];
							
							if( entry.rect.intersects( r ) )
								vRes.push( entry.indice );
						}
					}
					
					if( _bHasActiveChilds ){
						i = 0;
						for( i ; i < CHILDS_LEN ; i++ ){
							child = _vChildrens[ i ];
							if( child.hasChilds || child.activeChilds )
								if( child.rect.intersects( r ))
									child.getRectContent( r , vRes );
						};
					}
				}
			}
			
			/**
			* getRectContentAndValue function
			* @public
			* @param 
			* @return
			*/
			final public function getRectContentAndValue( r : Rectangle , aRES : Vector.<QuadTreeResult> ) : void {
			
				if( BoxRectangle.intersect( _oQuadRec , r ) ) {
					
					if( _bHasContent ){
						i = 0;
						l  = _vItems.length;
						for( i ; i < l ; i++ ){
							entry = _vItems[i];
							if( entry.rect.intersects( r ) )
								aRES.push( new QuadTreeResult( entry.indice , entry.rect ) );
						}
					}
					
					if( _bHasActiveChilds ){
						
						i = 0;
						
						for( i ; i < CHILDS_LEN ; i++ ){
							
							child = _vChildrens[ i ];
							if(child.hasChilds || child.activeChilds )
								if( child.rect.intersects( r ))
									child.getRectContentAndValue( r , aRES );
									
						}
						
					}
				}
			
			}
			
		// -------o protected
			
			/**
			* 
			*
			* @param 
			* @return
			*/
			protected function _init() : void {
				
				if( _iDepth <= _iDepthMax ){
					
					var nD : uint = _iDepth + 1;
					var nW : uint = _oQuadRec.width / 2;
					var nH : uint = _oQuadRec.height / 2;
					var oREC : Rectangle = new Rectangle( 0 , 0 , nW , nH );
					
					if( !_vChildrens ){
						_vChildrens = new Vector.<QuadTreeNode>();
					
					//TL
						_vChildrens.push( new QuadTreeNode( oREC , this, nD , _iDepthMax));
						
					//TR
						oREC.x = nW;
						_vChildrens.push( new QuadTreeNode( oREC , this, nD , _iDepthMax));
						
					//BL
						oREC.x = 0;
						oREC.y = nH;
						_vChildrens.push( new QuadTreeNode( oREC , this, nD , _iDepthMax));
						
					//BR
						oREC.x = nW;
						_vChildrens.push( new QuadTreeNode( oREC , this, nD , _iDepthMax));
					
					}
					_bHasChilds = true;
						
				}else
					_bHasChilds = false;
					_bInitialized = true;
				
			}
			
		// -------o misc

			public static function trc(...args : *) : void {
				Logger.log(QuadTreeNode, args);
			}
	}
}


