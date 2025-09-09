// deno-lint-ignore-file
import * as rm from "https://deno.land/x/remapper@4.2.0/src/mod.ts"
import * as bundleInfo from '../bundleinfo.json' with { type: 'json' }
import * as cache from '../RM_Cache.json' with { type: 'json' }
import {Times} from "./consts.ts"
let env: rm.Environment;

console.log("GIVE IT UP FOR RUN "+ (cache.default.runs +1))

const pipeline = await rm.createPipeline({ bundleInfo })

const map = await rm.readDifficultyV3(pipeline, 'ExpertPlusStandard')

const bundle = rm.loadBundle(bundleInfo)
const materials = bundle.materials
const prefabs = bundle.prefabs


// ----------- { SCRIPT } -----------

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

prefabs.spacescene.instantiate(map,Times.Space01)



// ----------- { OUTPUT } -----------

//!CHANGE THIS!!!!!!!


pipeline.export({
    outputDirectory: '/Users/un/Downloads/beat saber install/bsaber/Beat Saber_Data/CustomWIPLevels/FALL AWAY'
})


