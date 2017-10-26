#!/bin/bash

#must also be bash for the md5sum commands
set -e

if [ "$BUILD_TOOLS" = true ];
then
    md5sum -c - <<< "49bc6b1b9ed56c83cceb6674bd97cb34 *html/changelogs/example.yml";
    cd tgui && source ~/.nvm/nvm.sh && gulp && cd ..;
<<<<<<< HEAD
    php5.6 -l tools/WebhookProcessor/github_webhook_processor.php;
=======
    phpenv global 5.6
    php -l tools/WebhookProcessor/github_webhook_processor.php;
    php -l tools/TGUICompiler.php;
>>>>>>> 9b71dcb... Merge pull request #32050 from optimumtact/ripandtearthehugeguts
    python tools/ss13_genchangelog.py html/changelog.html html/changelogs;
fi;
