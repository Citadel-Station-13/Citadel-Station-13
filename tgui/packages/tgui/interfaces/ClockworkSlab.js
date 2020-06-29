import { useBackend, useSharedState } from '../backend';
import { map } from 'common/collections';
import { Section, Tabs, Table, Button, Box, NoticeBox, Divider } from '../components';
import { Fragment } from 'inferno';
import { Window } from '../layouts';

let REC_RATVAR = "";
for (let index = 0; index < Math.min(Math.random()*100); index++) {
  // HEY! is it faster to do it serverside or client side?
  REC_RATVAR.concat("HONOR RATVAR ");
}

export const ClockworkSlab = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    recollection = true,
    recollection_categories = [],
    rec_section = null,
    scripture = {}, // this is a {}, not a []
    tier_infos = {},
    power = "0 W",
    power_unformatted = 0,
    HONOR_RATVAR = false, // is ratvar free yet?
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
    <Window theme="clockcult">
      <Window.Content scrollable>
        <Fragment>
          <Section>
            <Button
              content={recollection ? "Recital" : "Recollection"}
              tooltip={"Tutorial"}
              tooltipPosition={"right"}
              onClick={() => act('toggle')}
            />
          </Section>
          {recollection
            ? ( // tutorial
              <Section title="Recollection">
                <Box>
                  {(HONOR_RATVAR
                  ) ? (
                   <Box
                      as={'span'}
                      textColor={'#BE8700'}
                      fontSize={2}
                      bold>
                      {REC_RATVAR}
                   </Box>
                    ) : (
                      <Fragment>
                        <Box
                          as={'span'}
                          textColor={'#BE8700'}
                          fontSize={2} // 2rem
                          bold>
                          Chetr nyy hagehguf naq ubabe Ratvar.
                        </Box>
                        <NoticeBox>
                          NOTICE: This information is out of date.
                          Read the Ark &amp; You primer in your backpack
                          or read the wiki page for current info.
                        </NoticeBox>
                        <Box>
                          These pages serve as the archives of Ratvar, the
                          Clockwork Justiciar. This section of your slab
                          has information on being as a Servant, advice
                          for what to do next, and pointers for serving the
                          master well. You should recommended that you check this
                          area for help if you get stuck or need guidance on
                          what to do next.
                          <br /> <br />
                          Disclaimer: Many objects, terms, and phrases, such as
                          Servant, Cache, and Slab, are capitalized like proper
                          nouns. This is a quirk of the Ratvarian language do
                          not let it confuse you! You are free to use the names
                          in pronoun form when speaking in normal languages.
                        </Box>
                      </Fragment>
                    )}
                </Box>
                {!!recollection_categories
                && recollection_categories.map(cat => {
                  return (
                    <Fragment key={cat.name} >
                      <br />
                      <Button
                        content={cat.name}
                        tooltip={cat.desc}
                        tooltipPosition={'right'}
                        onClick={() => act('rec_category', {
                          "category": cat.name,
                        })} />
                    </Fragment>
                  );
                })}
                <Box>
                  {data.rec_section}
                  <Box
                    as={'span'}
                    textColor={'#BE8700'}
                    fontSize={2.3}>
                    {rec_section ? (
                      '500 Server Internal archives not found.'
                    ) : (
                      rec_section.title
                    )}
                  </Box>
                  <br /><br />
                  {rec_section ? (
                    "One of the cogscarabs must've misplaced this section."
                  ) : (
                    rec_section.info
                  )}
                </Box>
                <br />
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
                  {!!data.rec_binds && data.rec_binds.map(bind => (
                    <Fragment key={bind.name} >
                      A <b>Quickbind</b> slot ({data.rec_binds[bind]}),
                      currently set to
                      <Box
                        as={'span'}
                        textColor={bind ? bind.color : "#BE8700"}
                        bold>
                        {bind ? bind.name : "None"}
                      </Box>
                      .
                      <br />
                    </Fragment>
                  ))}
                </Box>
              </Section>
            ) : (
              <Section title="Power">
                <b>{power}</b> power is available for scripture
                and other consumers.
                <Section level={2}>
                  <Tabs>
                    {map((scriptures, name) => {
                      return (
                        <Tabs.Tab
                          key={name}
                          selected={tab === name}
                          onClick={() => setTab(name)}>
                          {name}
                        </Tabs.Tab>
                      );
                    })(scripture)}
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
                    {!!scriptInTab && scriptInTab.map(script => (
                      <Table.Row
                        key={script.name}
                        className="candystripe">
                        <Table.Cell
                          italic={!!script.important}
                          color={script.fontcolor}>
                          {`
                            ${script.name}
                            ${script.descname}
                            ${script.invokers || ''}
                          `}
                        </Table.Cell>
                        <Table.Cell
                          collapsing
                          textAlign="right">
                          <Fragment>
                            <Button
                              content={`Recite ${script.required}`}
                              disabled={script.required_unformatted
                               >= power_unformatted}
                              tooltip={script.tip}
                              tooltipPosition={'left'}
                              onClick={() => act('recite', {
                                'script': script.type,
                              })} />
                            <Button
                              content={script.bound ? (
                                `Unbind ${script.bound}`
                              ) : (
                                'Quickbind'
                              )}
                              disabled={!script.quickbind}
                              onClick={() => act('bind', {
                                'script': script.type,
                              })} />
                          </Fragment>
                        </Table.Cell>
                      </Table.Row>
                    ))}
                  </Table>
                </Section>
              </Section>
            )}
        </Fragment>
      </Window.Content>
    </Window>
  );
};
