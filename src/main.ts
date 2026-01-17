import * as rm from "../remapper/src/mod.ts"
import * as bundleInfo from '../bundleinfo.json' with { type: 'json' }
import * as cache from '../RM_Cache.json' with { type: 'json' }
import {Times} from "./consts.ts"

console.log("GIVE IT UP FOR RUN "+ (cache.default.runs +1))

const pipeline = await rm.createPipeline({ bundleInfo })

const bundle = rm.loadBundle(bundleInfo)
const materials = bundle.materials
const prefabs = bundle.prefabs


// ----------- { SCRIPT } -----------


async function doMap(file: rm.DIFFICULTY_NAME) {
    const map = await rm.readDifficultyV3(pipeline, file)
    map.require("Chroma")
    map.require("Vivify")


    rm.environmentRemoval(map,["Environment"])
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


    // create ui stuff
    const HUD = prefabs.hud.instantiate(map,{beat: Times.Space01, track: "HUDTrack"})
    rm.animateTrack(map,{beat: Times.Space01, track: "HUDTrack", animation: {rotation: ["baseHeadRotation.s10"], position: ["baseHeadPosition.s10"]} })
    // instantiations and destruction
    const fakeHouse = prefabs.nuhouse.instantiate(map,Times.FakeHouse)
    fakeHouse.destroyObject(49)

    materials.static.blit(map,47,2)

    const Space01 = prefabs.spacescene.instantiate(map,Times.Space01)
    Space01.destroyObject(Times.HyperDrive01)

    const HyperDrive01 = prefabs.hyperdrive01.instantiate(map,Times.HyperDrive01)
    HyperDrive01.destroyObject(Times.Space02)

    const Space02 = prefabs.space02.instantiate(map,Times.Space02)
    Space02.destroyObject(Times.HyperDrive02)

    const HyperDrive02 = prefabs.hyperdrive01.instantiate(map,Times.HyperDrive02)
    HyperDrive02.destroyObject(Times.EarthClosing)

    prefabs.earthclosing.instantiate(map,Times.EarthClosing)



    // do da drop on those notes at the start
    rm.noteIterator().betweenTime(0,Times.Space01).addProcess(note => 
        note.animation.definitePosition = [
        [0, 4, 8, 0],
        [0, 0, 7, .25, 'easeOutSine'],
        [0, 0, 0, .5, 'easeLinear'],
        [0, 0, -20, 1]
    ]).addProcess(note => note.life = (5))
}

await Promise.all([
    doMap('ExpertPlusStandard'),
    doMap('ExpertStandard')
])


// ----------- { OUTPUT } -----------
pipeline.export({
    outputDirectory: '/Users/un/Downloads/FALLAWAY'
})


