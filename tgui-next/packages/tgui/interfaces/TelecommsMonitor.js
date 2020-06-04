import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { RADIO_CHANNELS } from '../constants';
import { Box, Button, LabeledList, NoticeBox, Section, Tabs, Input } from '../components';


export const Telemonitor = props => {
  const { act, data } = useBackend(props);
  const {
    notice,
    network = "NULL",
    servers,
    selected = null,
    selected_servers,
  } = data;
  const operational = (selected && selected.status);

  return (
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
                  content="Flush Buffer"
                  icon="minus-circle"
                  disabled={!servers.length || !!selected}
                  onClick={() => act('release')} />
                <Button
                  content="Probe Network"
                  icon="sync"
                  disabled={selected}
                  onClick={() => act('probe')} />
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
        <Tabs.Tab label="Network Entities">
          <Section title="Detected Network Entities">
            {(servers && servers.length) ? (
              <LabeledList>
                {servers.map(server => {
                  return (
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
                  );
                })}
              </LabeledList>
            ) : (
              '404 Servers not found. Have you tried scanning the network?'
            )}
          </Section>
        </Tabs.Tab>
        <Tabs.Tab
          label="Entity Status"
          disabled={!selected}>
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
              <LabeledList.Item
                label="Network Traffic"
                color={operational && (selected.netspeed < selected.traffic) ? (
                  'bad'
                ) : (
                  'good'
                )}>
                {operational ? ( // Not to be confused to totaltraffic
                  selected.traffic <= 1024 ? (
                    `${Math.max(selected.traffic, 0)} Gigabytes`
                  ) : (
                    `${Math.round(selected.traffic/1024)} Terrabytes`
                  )
                ) : (
                  '0 Gigabytes'
                )}
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
                  'true'
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
                        <span style={`color: ${valid.color}`}>
                          {`[${thing}] (${valid.name}) `}
                        </span>
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
                  {selected_servers.map(server => {
                    return (
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
                    );
                  })}
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
        </Tabs.Tab>
      </Tabs>
    </Fragment>
  );
};
