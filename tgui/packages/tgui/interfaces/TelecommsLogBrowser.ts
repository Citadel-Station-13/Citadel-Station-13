/**
 * @file
 * @copyright 2020 LetterN (https://github.com/LetterN)
 * @license MIT
 */
import { Fragment } from 'inferno';
import { Window } from '../layouts';
import { useBackend, useSharedState } from '../backend';
import { Button, LabeledList, NoticeBox, Section, Tabs, Input } from '../components';

export const TelecommsLogBrowser = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    notice,
    network = "NULL",
    servers,
    selected = null,
    selected_logs,
  } = data;
  const [
    tab,
    setTab,
  ] = useSharedState(context, 'tab', 'servers');
  const operational = (selected && selected.status);
  return (
    <Window
      theme="ntos"
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
                {servers ? (
                  `${servers.length} currently probed and buffered`
                ) : (
                  'Buffer is empty!'
                )}
              </LabeledList.Item>
              <LabeledList.Item
                label="Selected Server"
                buttons={(
                  <Button
                    disabled={!selected}
                    onClick={() => act('mainmenu')}>
                    Disconnect
                  </Button>
                )}>
                {selected ? (
                  `${selected.name} (${selected.id})`
                ) : (
                  "None (None)"
                )}
              </LabeledList.Item>
              <LabeledList.Item label="Recorded Traffic">
                {selected ? (
                  selected.traffic <= 1024 ? (
                    `${selected.traffic} Gigabytes`
                  ) : (
                    `${Math.round(selected.traffic/1024)} Terrabytes`
                  )
                ) : (
                  '0 Gigabytes'
                )}
              </LabeledList.Item>
              <LabeledList.Item
                label="Server Status"
                color={operational ? 'good' : 'bad'}>
                {operational ? (
                  'Running'
                ) : (
                  'Server down!'
                )}
              </LabeledList.Item>
            </LabeledList>
          </Section>
          <Tabs>
            <Tabs.Tab
              selected={tab === "servers"}
              icon="server"
              onClick={() => setTab("servers")}>
              Servers
            </Tabs.Tab>
            <Tabs.Tab
              disabled={!operational}
              icon="file"
              selected={tab === "messages"}
              onClick={() => setTab("messages")}>
              Messages
            </Tabs.Tab>
          </Tabs>
          {(tab === "messages" && operational) ? (
            <Section title="Logs">
              {(operational && selected_logs) ? (
                selected_logs.map(logs => (
                  <Section
                    level={4}
                    key={logs.ref}>
                    <LabeledList>
                      <LabeledList.Item
                        label="Filename"
                        buttons={(
                          <Button
                            onClick={() => act('delete', {
                              'value': logs.ref,
                            })}>
                            Delete
                          </Button>
                        )}>
                        {logs.name}
                      </LabeledList.Item>
                      <LabeledList.Item label="Data type">
                        {logs.input_type}
                      </LabeledList.Item>
                      {logs.source && (
                        <LabeledList.Item label="Source">
                          {`[${logs.source.name}]
                          (Job: [${logs.source.job}])`}
                        </LabeledList.Item>
                      )}
                      {logs.race && (
                        <LabeledList.Item label="Class">
                          {logs.race}
                        </LabeledList.Item>
                      )}
                      <LabeledList.Item label="Contents">
                        {logs.message}
                      </LabeledList.Item>
                    </LabeledList>
                  </Section>
                ))
              ) : (
                "No server selected!"
              )}
            </Section>
          ) : (
            <Section>
              {(servers && servers.length) ? (
                <LabeledList>
                  {servers.map(server => (
                    <LabeledList.Item
                      key={server.name}
                      label={`${server.ref}`}
                      buttons={(
                        <Button
                          selected={data.selected
                          && (server.ref === data.selected.ref)}
                          onClick={() => act('viewmachine', {
                            'value': server.id,
                          })}>
                          Connect
                        </Button>
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
