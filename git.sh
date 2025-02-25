#!/bin/bash

# CONSTANT COLOR
ORANGE='\033[3;33m'
NC='\033[0m' # No Color

git add *

printf "${ORANGE}\n## REMOVING FILES FROM 'add *' ## \n#################################\n${NC}"

# UNWANTED FILES
git rm --cached "S5/HLIN501 - Algorithmique de graphes/cours.pdf"

printf "${ORANGE}\n## STATUS ##\n############\n${NC}"
git status

printf "${ORANGE}## COMMIT MESSAGE ##\n####################\n${NC}"
read commitMessage

git commit -am "$commitMessage"

git push
