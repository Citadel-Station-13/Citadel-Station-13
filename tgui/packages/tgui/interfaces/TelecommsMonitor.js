/**
 * @file
 * @copyright 2020 LetterN (https://github.com/LetterN)
 * @license MIT
 */
import { Fragment } from 'inferno';
import { Window } from '../layouts';
import { useBackend, useSharedState } from '../backend';
import { RADIO_CHANNELS } from '../constants';
import { Box, Button, LabeledList, NoticeBox, Section, Tabs, Input, ProgressBar } from '../components';


export const TelecommsMonitor = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    notice,
    network = "NULL",
    servers,
    selected = null,
    selected_servers,
  } = data;
  const [
    tab,
    setTab,
  ] = useSharedState(context, 'tab', 'network-entity');
  const operational = (selected && selected.status);

  return (
    <Window
      theme="ntos"
      resizable
      width={575}
      height={400}>
      <Window.Content scrollable>
        <Fragment>
          {!!notice && (
            <NoticeBox>
              {notice}
            </NoticeBox>
          )}
          <Section title="Network Control">
            <LabeledList>
              <LabeledList.Item label="Network">
                <Input
                  value={network}
                  width="150px"
                  maxLength={15}
                  onChange={(e, value) => act('network', {
                    'value': value,
                  })} />
              </LabeledList.Item>
              <LabeledList.Item
                label="Memory"
                buttons={(
                  <Fragment>
                    <Button
                      icon="minus-circle"
                      disabled={!servers.length || !!selected}
                      onClick={() => act('release')}>
                      Flush Buffer
                    </Button>
                    <Button
                      icon="sync"
                      disabled={selected}
                      onClick={() => act('probe')}>
                      Probe Network
                    </Button>
                  </Fragment>
                )}>
                {!selected ? (
                  servers ? (
                    `${servers.length} currently probed and buffered`
                  ) : (
                    'Buffer is empty!'
                  )
                ) : (
                  selected_servers ? (
                    `${selected_servers.length} currently probed and buffered`
                  ) : (
                    'Connected devices is empty!'
                  )
                )}
              </LabeledList.Item>
              <LabeledList.Item
                label="Selected Entity"
                buttons={(
                  <Button
                    content="Disconnect"
                    icon="minus-circle"
                    disabled={!selected}
                    onClick={() => act('mainmenu')}
                  />
                )}>
                {selected ? (
                  `${selected.name} (${selected.id})`
                ) : (
                  "None (None)"
                )}
              </LabeledList.Item>
            </LabeledList>
          </Section>
          <Tabs>
            <Tabs.Tab
              selected={tab === "network-entity"}
              icon="server"
              onClick={() => setTab("network-entity")}>
              Network Entities
            </Tabs.Tab>
            <Tabs.Tab
              disabled={!selected}
              icon="tasks"
              selected={tab === "network-stat"}
              onClick={() => setTab("network-stat")}>
              Entity Status
            </Tabs.Tab>
          </Tabs>
          {(tab === "network-stat" && selected) ? (
            <Section title="Network Entity Status">
              <LabeledList>
                <LabeledList.Item
                  label="Status"
                  color={operational ? 'good' : 'bad'}>
                  {operational ? (
                    'Running'
                  ) : (
                    'Server down!'
                  )}
                </LabeledList.Item>
                <LabeledList.Item label="Network Traffic">
                  <ProgressBar
                    value={selected.traffic}
                    ranges={{
                      good: [ // 0-30%
                        -Infinity,
                        selected.netspeed*0.30,
                      ],
                      average: [ // 30-70%
                        selected.netspeed*0.31,
                        selected.traffic*0.70,
                      ],
                      bad: [ // 70-100%
                        selected.netspeed*0.71,
                        Infinity,
                      ],
                    }}>
                    {operational ? ( // Not to be confused to totaltraffic
                      selected.traffic <= 1024 ? (
                        `${Math.max(selected.traffic, 0)} Gigabytes`
                      ) : (
                        `${Math.round(selected.traffic/1024)} Terrabytes`
                      )
                    ) : (
                      '0 Gigabytes'
                    )}
                  </ProgressBar>
                </LabeledList.Item>
                <LabeledList.Item label="Network Speed">
                  {operational ? (
                    selected.netspeed <= 1024 ? (
                      `${selected.netspeed} Gigabytes/second`
                    ) : (
                      `${Math.round(selected.netspeed/1024)} Terrabytes/second`
                    )
                  ) : (
                    '0 Gigabytes/second'
                  )}
                </LabeledList.Item>
                <LabeledList.Item
                  label="Multi-Z Link"
                  color={(operational && selected.long_range_link) ? (
                    'good'
                  ) : (
                    'bad'
                  )}>
                  {(operational && selected.long_range_link) ? (
                    'true' // was capitalized before
                  ) : (
                    'false'
                  )}
                </LabeledList.Item>
                <LabeledList.Item label="Frequency Listening">
                  <Box>
                    {operational && selected.freq_listening.map(thing => {
                      const valid = RADIO_CHANNELS
                        .find(channel => channel.freq === thing);
                      return (
                        (valid) ? (
                          <Box as="span" color={valid.color}>
                            {`[${thing}] (${valid.name}) `}
                          </Box>
                        ) : (
                          `[${thing}] `
                        )
                      );
                    })}
                  </Box>
                </LabeledList.Item>
              </LabeledList>
              <Section
                title="Servers Linked"
                level={3}>
                {(operational && selected_servers) ? (
                  <LabeledList>
                    {selected_servers.map(server => (
                      <LabeledList.Item
                        key={server.name}
                        label={server.ref}
                        buttons={(
                          <Button
                            content="Connect"
                            onClick={() => act('viewmachine', {
                              'value': server.id,
                            })} />
                        )}>
                        {`${server.name} (${server.id})`}
                      </LabeledList.Item>
                    ))}
                  </LabeledList>
                ) : (
                  !operational ? (
                    "Server currently down! Cannot fetch the buffer list!"
                  ) : (
                    "Buffer is empty!"
                  )
                )}
              </Section>
            </Section>
          ) : (
            <Section title="Detected Network Entities">
              {(servers && servers.length) ? (
                <LabeledList>
                  {servers.map(server => (
                    <LabeledList.Item
                      key={server.name}
                      label={server.ref}
                      buttons={(
                        <Button
                          content="Connect"
                          selected={selected
                              && (server.ref === selected.ref)}
                          onClick={() => act('viewmachine', {
                            'value': server.id,
                          })} />
                      )}>
                      {`${server.name} (${server.id})`}
                    </LabeledList.Item>
                  ))}
                </LabeledList>
              ) : (
                '404 Servers not found. Have you tried scanning the network?'
              )}
            </Section>

          )}
        </Fragment>
      </Window.Content>
    </Window>
  );
};
