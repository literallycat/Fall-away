import * as rm from "https://deno.land/x/remapper@4.2.1/src/mod.ts"
import * as bundleInfo from '../bundleinfo.json' with { type: 'json' }
//import * as cache from '../RM_Cache.json' with { type: 'json' }
import {Times} from "./consts.ts"

//console.log("GIVE IT UP FOR RUN "+ (cache.default.runs +1))

const pipeline = await rm.createPipeline({ bundleInfo })

const bundle = rm.loadBundle(bundleInfo)
const materials = bundle.materials
const prefabs = bundle.prefabs

//deno run --allow-all src/main.ts
// ----------- { SCRIPT } -----------


async function doMap(file: rm.DIFFICULTY_NAME) {
    const map = await rm.readDifficultyV3(pipeline, file)
    map.require("Chroma")
    map.require("Vivify")
    map.require("AudioLink")
   
    // stop breaking shit rahhhh

    
    map.difficultyInfo.settingsSetter = {
        colors: {},
        graphics: {
            // maxShockwaveParticles: 0,
            screenDisplacementEffectsEnabled: false
        },
        chroma: {
            disableEnvironmentEnhancements: false
        },
        modifiers: {},
        environments: {},
        playerOptions: {
            leftHanded: false,
            noTextsAndHuds: true,
            reduceDebris: true,
            hideNoteSpawnEffect: true

        }
    }

    rm.environmentRemoval(map,["Environment","GameCore"])
   // rm.assignObjectPrefab(map, {
     //   saber: {
       //     type: 'Both',
          //  asset: prefabs["rsih saber"].path,
            //trailAsset: materials.rsih_saber_trail.path,
         // trailTopPos: [0, 0, -1],
         //   trailBottomPos: [0, 0, -1],
           // trailDuration: 0.2,
          //  trailSamplingFrequency: 100,
       // },
   // })
    rm.assignObjectPrefab(map, {
        saber: {
            type: 'Both',
            asset: prefabs["rsih saber"].path,
            trailAsset: materials.rsih_saber_trail.path,
            trailTopPos: [0, 0, 1.1],
            trailBottomPos: [0, 0, 0.1],
            trailDuration: 0.2,
            trailSamplingFrequency: 100,
        },
    })
    rm.setRenderingSettings(map,{
        beat: 0,
        renderSettings: {
            "ambientIntensity": 0
        }
    })
    

    // create ui stuff
    const _HUD = prefabs.hudenabled.instantiate(map,{ beat: Times.Space01, track: "HUDTrack"})
    const _DesktopHUD = prefabs.hudfaraway.instantiate(map,Times.Space01)
    rm.animateTrack(map,{beat: Times.Space01, track: "HUDTrack", duration: 99999, animation: {rotation: ["baseHeadRotation.s10"], position: ["baseHeadPosition.s10"]} })
    materials.rendershit.blit(map,{beat: Times.Space01, duration: 99999, priority: 10, order: "BeforeMainEffect"})
    materials.static.blit(map,47,2)
    // instantiations and destructionk
    const fakeHouse = prefabs.nuhouse.instantiate(map,Times.FakeHouse)
    const Space01 = prefabs.spacescene.instantiate(map,Times.Space01)
    const HyperDrive01 = prefabs.hyperdrive01.instantiate(map)
    const Space02 = prefabs.space02.instantiate(map)
    const HyperDrive02 = prefabs.hyperdrive02.instantiate(map)
    const earthclose = prefabs.finalscene.instantiate(map)
    const dumbassText = prefabs.texthost.instantiate(map)
    prefabs.endhouse.instantiate(map)
    
    fakeHouse.destroyObject(49)
    Space01.destroyObject(Times.HyperDrive01)
    HyperDrive01.destroyObject(Times.Space02)
    Space02.destroyObject(Times.HyperDrive02)
    HyperDrive02.destroyObject(Times.EarthClosing)
    dumbassText.destroyObject(397)
    earthclose.destroyObject(579)

}

await Promise.all([
    doMap('ExpertPlusStandard'),
    doMap('ExpertStandard')
])


// ----------- { OUTPUT } -----------
pipeline.export({
    outputDirectory: "C:\\Users\\cat\\BSManager\\BSInstances\\1.40.8\\Beat Saber_Data\\CustomWIPLevels\\FALLAWAY",
zip: {
        name: 'fall',
        includeBundles: true
    },
})
