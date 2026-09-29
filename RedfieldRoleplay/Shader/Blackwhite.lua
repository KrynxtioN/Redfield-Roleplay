local screenX,screenY = guiGetScreenSize()
local screenSource = dxCreateScreenSource(screenX,screenY)
local blackWhiteShader = dxCreateShader('Shader/Blackwhite.fx')

function blackWhiteScreen()
    if(blackWhiteShader)then
        dxUpdateScreenSource(screenSource)     
        dxSetShaderValue(blackWhiteShader,'screenSource',screenSource)
		dxDrawImage(0,0,screenX,screenY,blackWhiteShader)
    end
end