import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Button, LabeledList, NoticeBox, Section, Input } from '../components';

export const Telemonitor = props => {
  const { act, data } = useBackend(props);
  const {
    notice,
    network = "NULL",
    servers,
    selected = null,
    selected_servers,
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
      <Section title="Detected Network Entities">
        {selected ? (
          selected_servers ? (
            <LabeledList>
              {selected_servers.map(servers => {
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
          ) : (
            "Connected devices is empty!"
          )
        ) : (
          servers ? (
            <LabeledList>
              {servers.map(server => {
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
          ) : (
            "Buffer is empty!"
          )
        )}
      </Section>
    </Fragment>
  );
};
