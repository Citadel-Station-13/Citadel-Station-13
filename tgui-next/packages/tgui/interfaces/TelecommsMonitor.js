import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Button, LabeledList, NoticeBox, Section, Tabs, Input } from '../components';


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
  const freqcolorMap = { // red team, blue team and syndie is not included
    1337: '#686868', // central
    1347: '#a8732b', // cargonia
    1349: '#008000', // service
    1351: '#993399', // science
    1353: '#948f02', // command
    1355: '#337296', // medical
    1357: '#fb5613', // engineering
    1359: '#a30000', // security
    1459: '#008000', // common
  };

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
                  '0 Giabytes'
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
                  '0 Giabytes/second'
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
                instead of this garbage, do some fancy thing
                {operational ? JSON.stringify(selected.freq_listening) : '[]'}
              </LabeledList.Item>
              <br />
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
                "Buffer is empty!"
              )}
            </Section>
          </Section>
        </Tabs.Tab>
      </Tabs>
    </Fragment>
  );
};
