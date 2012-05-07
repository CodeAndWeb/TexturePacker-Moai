----------------------------------------------------------------
-- Copyright (c) 2010-2011 Zipline Games, Inc. 
-- All Rights Reserved. 
-- http://getmoai.com
----------------------------------------------------------------

function printf ( ... )
	return io.stdout:write ( string.format ( ... ))
end

viewport = MOAIViewport.new ()
viewport:setSize ( 640, 480 )
viewport:setScale ( 640, -480 )
layer = MOAILayer2D.new ()
layer:setViewport ( viewport )

MOAISim.pushRenderPass ( layer )
MOAISim.openWindow ( "texturepacker-spritedeck", 640, 480 )

local spriteLibs = dofile ( 'spritedeck.lua' )

function loadSpriteLibs ( specList )

	local list = {}
	
	local texture = MOAITexture.new ()
	texture:load ( specList.texture )
	
	for i, spec in ipairs ( specList ) do
		
		local spriteLib = MOAIGfxQuadListDeck2D.new ()
		table.insert ( list, spriteLib );
		
		spriteLib:reserveUVQuads ( #spec.uvRects )
		for j, uvRect in ipairs ( spec.uvRects ) do
			
			if uvRect.r then
				spriteLib:setUVQuad ( j,
					uvRect.x0, uvRect.y0,
					uvRect.x0, uvRect.y1,
					uvRect.x1, uvRect.y1,
					uvRect.x1, uvRect.y0
				)
			else
				spriteLib:setUVRect ( j, uvRect.x0, uvRect.y0, uvRect.x1, uvRect.y1 )
			end
		end

		spriteLib:reserveQuads ( #spec.quads )
		for j, quad in ipairs ( spec.quads ) do
			if quad.x0 ~= nil then
				spriteLib:setRect ( j, quad.x0, quad.y0, quad.x1, quad.y1 )
			else
				spriteLib:setQuad ( j,
					quad.v0.x, quad.v0.y,
					quad.v1.x, quad.v1.y,
					quad.v2.x, quad.v2.y,
					quad.v3.x, quad.v3.y
				)
			end
		end
		
		spriteLib:reservePairs ( #spec.prims )
		for j, prim in ipairs ( spec.prims ) do
			spriteLib:setPair ( j, prim.uv, prim.q )
		end
		
		spriteLib:reserveLists ( #spec.sprites )
		for j, sprite in ipairs ( spec.sprites ) do
			spriteLib:setList ( j, sprite.base, sprite.size )
		end
		
		spriteLib:setTexture ( texture )
    	spriteLib.names = specList.names
	end
	
	
	return list
end

spriteLibs = loadSpriteLibs ( spriteLibs )
spriteLib = spriteLibs [ 1 ]

function onMouseLeftEvent ( down )
	if MOAIInputMgr.device.mouseLeft:down () then
        sprite = MOAIProp2D.new ()
        sprite:setDeck ( spriteLib )
        layer:insertProp ( sprite )
		sprite:setIndex ( spriteLib.names['hotdog.png'] )
        local x,y=MOAIInputMgr.device.pointer:getLoc()
		sprite:setLoc (x-320,y-240)
	end
end

MOAIInputMgr.device.mouseLeft:setCallback ( onMouseLeftEvent )

function onMouseRightEvent ( down )
	if MOAIInputMgr.device.mouseRight:down () then
        sprite = MOAIProp2D.new ()
        sprite:setDeck ( spriteLib )
        layer:insertProp ( sprite )
		sprite:setIndex ( spriteLib.names['drink.png'] )
        local x,y=MOAIInputMgr.device.pointer:getLoc()
		sprite:setLoc (x-320,y-240)
	end
end

MOAIInputMgr.device.mouseRight:setCallback ( onMouseRightEvent )
