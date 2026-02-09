#!/bin/bash

DATA_PATH= "/Users/f007f8t/Documents/GitHub/Sensitivity_SRedits/polynomial"

cd /Users/f007f8t/Documents/GitHub/Sensitivity_SRedits/polynomial
Rscript 1_2-10D.R "$DATA_PATH"

cd /Users/f007f8t/Documents/GitHub/Sensitivity_SRedits/polynomial
Rscript 2_2-10D.R "$DATA_PATH"

cd /Users/f007f8t/Documents/GitHub/Sensitivity_SRedits/polynomial
Rscript 3_2D.R "$DATA_PATH"

cd /Users/f007f8t/Documents/GitHub/Sensitivity_SRedits/polynomial
Rscript 3_5D.R "$DATA_PATH"

cd /Users/f007f8t/Documents/GitHub/Sensitivity_SRedits/polynomial
Rscript 3_10D.R "$DATA_PATH"

cd /Users/f007f8t/Documents/GitHub/Sensitivity_SRedits/polynomial
Rscript 4_2-10D.R "$DATA_PATH"