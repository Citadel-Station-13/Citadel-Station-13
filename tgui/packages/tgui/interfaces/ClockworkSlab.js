/**
 * @file
 * @copyright 2021 LetterN (https://github.com/LetterN)
 * @author Original LetterN (https://github.com/LetterN)
 * @author Changes arturlang
 * @license MIT
 */

import { useBackend, useSharedState } from '../backend';
import { map } from 'common/collections';
import { Section, Tabs, Table, Button, Box, NoticeBox, Divider } from '../components';
import { Fragment } from 'inferno';
import { Window } from '../layouts';

let REC_RATVAR = "";
// You may ask "why is this not inside ClockworkSlab"
// It's because cslab gets called every time. Lag is bad.
for (let index = 0; index < Math.min(Math.random()*100); index++) {
  REC_RATVAR += "HONOR RATVAR ";
}

export const ClockworkSlab = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    recollection = true,
    scripture = {},
    tier_infos = {},
    power = "0 W",
  } = data;
  const [
    tab,
    setTab,
  ] = useSharedState(context, 'tab', 'Application');
  const scriptInTab = scripture
  && scripture[tab]
  || [];
  const tierInfo = tier_infos
  && tier_infos[tab]
  || {};

  return (
    <Window
      theme="clockcult"
      width={800}
      height={420}>
      <Window.Content scrollable>
        {recollection ? ( // tutorial
          <CSTutorial />
        ) : (
          <Section
            title="Power"
            buttons={(
              <Button
                icon="book"
                tooltip={"Tutorial"}
                tooltipPosition={"left"}
                onClick={() => act('toggle')}>
                Recollection
              </Button>
            )}>
            <b>{power}</b> power is available for scripture
            and other consumers.
            <Section level={2}>
              <Tabs>
                {map((scriptures, name) => (
                  <Tabs.Tab
                    key={name}
                    selected={tab === name}
                    onClick={() => setTab(name)}>
                    {name}
                  </Tabs.Tab>
                ))(scripture)}
              </Tabs>
              <Box
                as={'span'}
                textColor={'#B18B25'}
                bold={!!tierInfo.ready} // muh booleans
                italic={!tierInfo.ready}>
                {tierInfo.ready ? (
                  "These scriptures are permanently unlocked."
                ) : (
                  tierInfo.requirement
                )}
              </Box>
              <br />
              <Box as={'span'} textColor={'#DAAA18'}>
                Scriptures in <b>yellow</b> are related to
                construction and building.
              </Box>
              <br />
              <Box as={'span'} textColor={'#6E001A'}>
                Scriptures in <b>red</b> are related to
                attacking and offense.
              </Box>
              <br />
              <Box as={'span'} textColor={'#1E8CE1'}>
                Scriptures in <b>blue</b> are related to
                healing and defense.
              </Box>
              <br />
              <Box as={'span'} textColor={'#AF0AAF'}>
                Scriptures in <b>purple</b> are niche but
                still important!
              </Box>
              <br />
              <Box as={'span'} textColor={'#DAAA18'} italic>
                Scriptures with italicized names are
                important to success.
              </Box>
              <Divider />
              <Table>
                <CSScripture scriptInTab={scriptInTab} />
              </Table>
            </Section>
          </Section>
        )}
      </Window.Content>
    </Window>
  );
};

export const CSScripture = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    power_unformatted = 0,
  } = data;
  const {
    scriptInTab,
  } = props;

  return (
    scriptInTab?.map(script => (
      <Table.Row
        key={script.name}
        className="candystripe">
        <Table.Cell
          italic={!!script.important}
          color={script.fontcolor}>
          <b>
            {script.name}
          </b>
          {`
              ${script.descname}
              ${script.invokers || ''}
            `}
        </Table.Cell>
        <Table.Cell
          collapsing
          textAlign="right">
          <Button
            disabled={
              script.required_unformatted >= power_unformatted
            }
            tooltip={script.tip}
            tooltipPosition={'left'}
            onClick={() => act('recite', {
              'script': script.type,
            })} >
            {`Recite ${script.required}`}
          </Button>
        </Table.Cell>
        <Table.Cell
          collapsing
          textAlign="center">
          <Button
            fluid
            disabled={!script.quickbind}
            onClick={() => act('bind', {
              'script': script.type,
            })}>
            {script.bound ? (
              `Unbind ${script.bound}`
            ) : (
              'Quickbind'
            )}
          </Button>
        </Table.Cell>
      </Table.Row>
    ))
  );
};

export const CSTutorial = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    recollection_categories = [],
    rec_section = null,
    rec_binds = [],
    HONOR_RATVAR = false, // is ratvar free yet?
  } = data;
  return (
    <Section
      title="Recollection"
      buttons={(
        <Button
          icon="cog"
          tooltipPosition={"left"}
          onClick={() => act('toggle')}>
          Recital
        </Button>
      )}>
      <Box>
        {HONOR_RATVAR ? (
          <Box
            as="span"
            textColor="#BE8700"
            fontSize={2}
            bold>
            {REC_RATVAR}
          </Box>
        ) : (
          <Fragment>
            <Box
              as="span"
              textColor="#BE8700"
              fontSize={2} // 2rem
              bold>
              Chetr nyy hagehguf naq ubabe Ratvar.
            </Box>
            <NoticeBox warning>
              NOTICE: This information is out of date.
              Read the Ark &amp; You primer in your backpack
              or read the wiki page for current info.
            </NoticeBox>
            These pages serve as the archives of Ratvar, the
            Clockwork Justiciar. This section of your slab
            has information on being as a Servant, advice
            for what to do next, and pointers for serving the
            master well. You should recommended that you check this
            area for help if you get stuck or need guidance on
            what to do next.
            <br /> <br />
            <NoticeBox info>
              Disclaimer: Many objects, terms, and phrases, such as
              Servant, Cache, and Slab, are capitalized like proper
              nouns. This is a quirk of the Ratvarian language do
              not let it confuse you! You are free to use the names
              in pronoun form when speaking in normal languages.
            </NoticeBox>
          </Fragment>
        )}
      </Box>
      {recollection_categories?.map(cat => (
        <Fragment key={cat.name}>
          <br />
          <Button
            tooltip={cat.desc}
            tooltipPosition={'right'}
            onClick={() => act('rec_category', {
              "category": cat.name,
            })} >
            {cat.name}
          </Button>
        </Fragment>
      ))}
      <Divider />
      <Box>
        <Box
          as={'span'}
          textColor={'#BE8700'}
          fontSize={2.3}>
          {rec_section?.title ? (
            rec_section.title
          ) : (
            '500 Slab Internal archives not found.'
          )}
        </Box>
        <br /><br />
        {rec_section?.info ? (
          rec_section.info
        ) : (
          "One of the cogscarabs must've misplaced this section."
        )}
      </Box>
      <br />
      <Divider />
      <Box>
        <Box
          as={'span'}
          textColor={'#BE8700'}
          fontSize={2.3}>
          Quickbound Scripture
        </Box>
        <br />
        <Box as={'span'} italic>
          You can have up to five scriptures bound to
          action buttons for easy use.
        </Box>
        <br /><br />
        {rec_binds?.map(bind => (
          <Fragment key={bind.name ? bind.name : "none"}>
            A <b>Quickbind</b> slot ({rec_binds.indexOf(bind)+1}),
            currently set to&nbsp;
            <span style={`color:${bind ? bind.color : "#BE8700"}`}>
              {bind?.name ? bind.name : "None"}
            </span>
            .
            <br />
          </Fragment>
        ))}
      </Box>
    </Section>
  );
};
