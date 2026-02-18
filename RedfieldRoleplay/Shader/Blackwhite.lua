local screenX,screenY = guiGetScreenSize()
local screenSource = dxCreateScreenSource(screenX,screenY)

addEventHandler('onClientResourceStart',getResourceRootElement(getThisResource()),function()
	blackWhiteShader = dxCreateShader('Shader/Blackwhite.fx')
end)

function blackWhiteScreen()
    if(blackWhiteShader)then
        dxUpdateScreenSource(screenSource)     
        dxSetShaderValue(blackWhiteShader,'screenSource',screenSource)
		dxDrawImage(0,0,screenX,screenY,blackWhiteShader)
    end
end