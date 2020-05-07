import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Button, LabeledList, NoticeBox, Section, Tabs, Input } from '../components';

export const Telemonitor = props => {
  const { act, data } = useBackend(props);
  return (
    <Fragment>
      {!!data.notice && (
        <NoticeBox>
          {data.notice}
        </NoticeBox>
      )}
      <Section title="Network Control">
        <LabeledList>
          <LabeledList.Item
            label="Network">
            <Input
              value={data.network}
              maxLength={15}
              onChange={(e, value) => act('network', {
                "value": value,
              })} />
          </LabeledList.Item>
          <LabeledList.Item
            label="Memory"
            buttons={(
              <Fragment>
                <Button
                  content="Flush Buffer"
                  icon="eject"
                  disabled={!data.servers.length || !!data.selected}
                  onClick={() => act('release')} />
                <Button
                  content="Probe Network"
                  icon="sync"
                  disabled={data.selected}
                  onClick={() => act('probe')} />
              </Fragment>
            )}>
            {!data.selected  // if there is a way to make this better, please do fix this mess
              ?(!!data.servers
                ?`${data.servers.length} currently probed and buffered`
                :'Buffer is empty!')
              :(!!data.selected_servers
                ?`${data.selected_servers.length}
                  currently probed and buffered`
                :'Connected devices is empty!')}
          </LabeledList.Item>
          {!!data.selected && (
            <LabeledList.Item
              label="Selected Network Entity"
              buttons={(
                <Button
                  content="Disconnect"
                  onClick={() => act('mainmenu')}
                />
              )}>
              {`${data.selected.name} (${data.selected.id})`}
            </LabeledList.Item>
          )}
        </LabeledList>
      </Section>
      <Section title="Detected Network Entities">
        {!data.selected && (
          <LabeledList>
            {data.servers.map(server => {
              return (
                <LabeledList.Item
                  key={server.name}
                  label={`${server.ref}`} // should i just md5 this and cut
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
        )}
        {!!data.selected && (
          <LabeledList>
            {data.selected_servers.map(servers => {
              return (
                <LabeledList.Item
                  key={servers.name}
                  label={`${servers.ref}`} // should i just md5 this and cut
                  buttons={(
                    <Button
                      content="Connect"
                      onClick={() => act('viewmachine', {
                        'value': servers.id,
                      })} />
                  )}>
                  {`${servers.name} (${servers.id})`}
                </LabeledList.Item>
              );
            })}
          </LabeledList>
        )}
      </Section>
    </Fragment>
  );
};

export const Logbrowser = props => {
  const { act, data } = useBackend(props);
  return (
    <Fragment>
      {!!data.notice && (
        <NoticeBox>
          {data.notice}
        </NoticeBox>
      )}
      <Section title="Network Control">
        <LabeledList>
          <LabeledList.Item
            label="Network">
            <Input
              value={data.network}
              maxLength={15}
              onChange={(e, value) => act('network', {
                "value": value,
              })} />
          </LabeledList.Item>
          <LabeledList.Item
            label="Memory"
            buttons={(
              <Fragment>
                <Button
                  content="Flush Buffer"
                  icon="eject"
                  disabled={!data.servers.length}
                  onClick={() => act('release')} />
                <Button
                  content="Probe Network"
                  icon="sync"
                  disabled={data.selected}
                  onClick={() => act('probe')} />
              </Fragment>
            )}>
            {data.selected
              ?(data.servers
                ?`${data.servers.length} currently probed and buffered`
                :'Buffer is empty!')
              :(data.selected_servers
                ?`${data.selected.name} buffered.
                  Currently has ${data.selected_servers.length}
                  network entities connected`
                :'Connected devices is empty!')}
          </LabeledList.Item>
          {!!data.selected && (
            <LabeledList.Item
              label="Selected Network Entity"
              buttons={(
                <Button
                  content="Disconnect"
                  onClick={() => act('mainmenu')}
                />
              )}>
              {`${data.selected.name} (${data.selected.id})`}
            </LabeledList.Item>
          )}
        </LabeledList>
      </Section>
      <Tabs>
        <Tabs.Tab
          key="servers"
          label="Servers">
          {() => (
            <Section>
              This is a custom list, showing the icon of the servers
            </Section>
          )}
        </Tabs.Tab>
        <Tabs.Tab
          key="messages"
          label="Messages">
          {() => (
            <Section>
              This is a custom list, showing erp logs
            </Section>
          )}
        </Tabs.Tab>
      </Tabs>
    </Fragment>
  );
};
