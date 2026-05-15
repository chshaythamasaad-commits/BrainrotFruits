local LOCAL_COURSE_SHAPE_TEST_ONLY = true

if LOCAL_COURSE_SHAPE_TEST_ONLY then
	print("[BrainrotFruits] BrainrotMap bootstrap disabled locally so the new GeneratedCourseShape can be tested by itself.")
	return
end

local PlotService = require(script.Parent.Map.PlotService)

PlotService.init()
