--[[ Make a custom GTW window ]]--
function createWindow(x, y, width, height, text, relative )
	local window = guiCreateStaticImage(x, y, width, height, "img/back.png", relative )
	local winTitle = guiCreateLabel((width/2)-((string.len(text)*7)/2), 3, (string.len(text)*10), 20, text, relative, window)
	local winTitleFont = guiCreateFont( "fonts/RobotoSlab-Bold.ttf", 11 )
	local winFont = guiCreateFont( "fonts/RobotoSlab-Bold.ttf", 10 )
	
	guiSetFont( winTitle, winTitleFont )	
	return window
end

--[[ Walrus default font ]]--
function setDefaultFont(inputElement, size)
	local font = guiCreateFont("fonts/RobotoSlab-Bold.ttf", size) 
	guiSetFont( inputElement, font )
end