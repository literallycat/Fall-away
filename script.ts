// deno-lint-ignore-file
import * as rm from "https://deno.land/x/remapper@4.1.0/src/mod.ts"
import * as bundleInfo from './bundleinfo.json' with { type: 'json' }
import * as cache from './RM_Cache.json' with { type: 'json' }
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

prefabs.housescene.instantiate(map)


// ----------- { OUTPUT } -----------

//!CHANGE THIS!!!!!!!


pipeline.export({
    outputDirectory: '../OutputMaps/test'
})


