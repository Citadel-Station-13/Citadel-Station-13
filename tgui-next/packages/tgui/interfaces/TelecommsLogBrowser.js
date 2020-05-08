import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Button, LabeledList, NoticeBox, Section, Tabs, Input } from '../components';

export const TeleLogBrowser = props => {
  const { act, data } = useBackend(props);
  const {
    notice,
    network = "NULL",
    servers,
    selected = null,
    selected_logs,
  } = data;
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
            {servers ? (
              `${servers.length} currently probed and buffered`
            ) : (
              'Buffer is empty!'
            )}
          </LabeledList.Item>
          <LabeledList.Item
            label="Selected Entity"
            buttons={(
              <Button
                content="Disconnect"
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
          key="servers"
          label="Servers">
          <Section>
            {(servers && servers.length) ? (
              <LabeledList>
                {servers.map(server => {
                  return (
                    <LabeledList.Item
                      key={server.name}
                      label={`${server.ref}`}
                      buttons={(
                        <Button
                          content="Connect"
                          selected={data.selected
                            && (server.ref === data.selected.ref)}
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
              '404 Servers not found'
            )}
          </Section>
        </Tabs.Tab>
        <Tabs.Tab
          key="messages"
          label="Messages">
          <Section>
            {selected_logs ? (
              selected_logs.map(logs => {
                return (
                  <Section key={logs.ref}>
                    <LabeledList>
                      <LabeledList.Item
                        label="Filename"
                        buttons={(
                          <Button
                            content="Delete"
                            onClick={() => act('delete', {
                              'value': logs.ref,
                            })} />
                        )}>
                        {logs.name}
                      </LabeledList.Item>
                      <LabeledList.Item label="Data type">
                        {logs.input_type}
                      </LabeledList.Item>
                      {logs.source && (
                        <LabeledList.Item label="Source">
                          {`[${logs.source.name}] (Job: [${logs.source.job}])`}
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
                );
              })
            ) : (
              "No server selected!"
            )}
          </Section>
        </Tabs.Tab>
      </Tabs>
    </Fragment>
  );
};
