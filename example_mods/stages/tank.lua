function onCreate()
    -- note: Everything is layered in the order that it is loaded, which is why the sky is added before the ground.
        
    
    makeLuaSprite('tanksky','tankSky', -350, -300)
    scaleObject('tanksky', 1.1, 1.1)

    makeLuaSprite('tankclouds','tankClouds', -350, -100)
    setLuaSpriteScrollFactor('tankclouds', 0.3, -0.02)
    
    makeLuaSprite('tankmountain','tankMountains', 500, 50)
    setLuaSpriteScrollFactor('tankmountain', 0.5, 0.01)

    makeLuaSprite('tankmountain2','tankMountains', -800, 50)
    setLuaSpriteScrollFactor('tankmountain2', 0.5, 0.01)
    
    makeLuaSprite('tankbuildings','tankBuildings', -350, 100)
    setLuaSpriteScrollFactor('tankbuildings', 1.5, 0.1) 
    scaleObject('tankbuildings', 1.1, 1.1)   
    
    makeLuaSprite('tankruins','tankRuins', 0, 100)
    setLuaSpriteScrollFactor('tankruins', 0.75, 0.1)
    scaleObject('tankruins', 1, 1)

    makeLuaSprite('tankruins2','tankRuins', -100, 100)
    setLuaSpriteScrollFactor('tankruins2', 0.75, 0.1)
    
    makeLuaSprite('tankground','tankGround', -225, 0)
    
    
    if not lowQuality then

        makeAnimatedLuaSprite('privateskittles','tankWatchtower', -50, 150)
        addAnimationByPrefix('privateskittles','watching','watchtower gradient color',24,true)
        addLuaSprite('privateskittles',false)

        makeAnimatedLuaSprite('tankmenbopper1','tank0', -225, 600)
        addAnimationByPrefix('tankmenbopper1','bop1','fg tankhead far right',24,true)
        addLuaSprite('tankmenbopper1',true)

        makeAnimatedLuaSprite('tankmenbopper6','tank5', 1150, 750)
        addAnimationByPrefix('tankmenbopper6','bop6','fg tankhead far left',24,true)
        addLuaSprite('tankmenbopper6',true)
    
        makeAnimatedLuaSprite('tankmenbopper5','tank4', 1300, 700)
        addAnimationByPrefix('tankmenbopper5','bop5','fg tankman bobbin 3',24,true)
        addLuaSprite('tankmenbopper5',true)
    
        makeAnimatedLuaSprite('tankmenbopper2','tank1', 750, 925)
        addAnimationByPrefix('tankmenbopper2','bop2','fg tankhead 5')
        addLuaSprite('tankmenbopper2',true)        
        
        makeAnimatedLuaSprite('tankmenbopper3','tank2', 500, 800)
        addAnimationByPrefix('tankmenbopper3','bop3','foreground man 3')
        addLuaSprite('tankmenbopper3',true)    

        makeAnimatedLuaSprite('tankmenbopper4','tank3', -25, 925)
        addAnimationByPrefix('tankmenbopper4','bop4','fg tankhead 4')
        addLuaSprite('tankmenbopper4',true)
    end
    --adding shit
    addLuaSprite('tanksky',false)
    addLuaSprite('tankclouds',false) 
    addLuaSprite('tankmountain',false) 
    addLuaSprite('tankmountain2',false)
    addLuaSprite('tankbuildings',false)
	addLuaSprite('tankruins',false)
    addLuaSprite('tankruins2',false)
    addLuaSprite('tankground',false)
end

function onBeatHit()--for every beat
	objectPlayAnimation('tankmenbopper1','bop1',true)
    objectPlayAnimation('tankmenbopper1copy','bop1copy',true)
    objectPlayAnimation('tankmenbopper2','bop2',true)
    objectPlayAnimation('tankmenbopper3','bop3',true) 
    objectPlayAnimation('tankmenbopper4','bop4',true)
    objectPlayAnimation('tankmenbopper5','bop5',true) 
    objectPlayAnimation('tankmenbopper6','bop6',true)
    objectPlayAnimation('privateskittles','watching',true) 
   

end

function onStepHit()--for every step
	
end

function onUpdate()

end