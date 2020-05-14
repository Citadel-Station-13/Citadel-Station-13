import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { act as _act } from '../byond';
import { Button, LabeledList, NoticeBox, Section, Tabs, Input } from '../components';

export const TelePDALog = props => {
  const { act, data } = useBackend(props);
  const {
    network,
    authenticated = false,
    status = true,
    canhack = false,
    selected = null,
    servers = [],
    message_logs = [],
    recon_logs = [],
  } = data;
  const valid = (status && selected && authenticated);

  if (data.hacking) {
    return ( // should have used en -> jp unicode -> other encoding method->utf8
      <Fragment>
        <NoticeBox>
          {"%$�(�:SYS&EM INTRN@L ACfES VIOL�TIa█ DEtE₡TED! Ree3AR\
            cinG A█ BAaKUP RdST�RE PbINT [0xcff32ca/ - PLfASE aAIT"}
        </NoticeBox>
        <Section>
          {data.hacking_msg}
        </Section>
      </Fragment> // ai gets to see normaltext while people see base64
    );
  }

  return (
    <Fragment>
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
                  disabled={!servers.length}
                  onClick={() => act('release')} />
                <Button
                  content="Probe Network"
                  icon="sync"
                  disabled={servers.length}
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
            label="Authentication"
            color={authenticated ? 'good' : 'bad'}
            buttons={(
              <Fragment>
                <Button
                  content="Change Password"
                  disabled={!authenticated || !selected}
                  onClick={() => act('changepass')}
                />
                {canhack && (
                  <Button
                    content="Brute Force"
                    disabled={authenticated || !selected}
                    onClick={() => act('hack')}
                  />
                )}
              </Fragment>
            )}>
            {authenticated ? "KEY OK" : "KEY FAIL"}
          </LabeledList.Item>
          <LabeledList.Item
            label="PDA Server"
            buttons={(
              <Fragment>
                <Button
                  content="Authenticate"
                  icon={authenticated ? 'unlock' : 'lock'}
                  disabled={!selected}
                  onClick={() => act('auth')}
                />
                <Button
                  content="Disconnect"
                  disabled={!selected}
                  onClick={() => act('mainmenu')}
                />
              </Fragment>
            )}>
            {selected ? (
              `${selected.name} (${selected.id})`
            ) : (
              "None (None)"
            )}
          </LabeledList.Item>
          <LabeledList.Item
            label="PDA Server Status"
            color={(status && selected) ? 'good' : 'bad'}>
            {selected ? (
              status ? (
              'Running'
              ) : (
              'Server down! Log functionality unaccessable!'
              )
            ):(
              'No server selected'
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
              '404 Servers not found. Have you tried scanning the network?'
            )}
          </Section>
        </Tabs.Tab>
        <Tabs.Tab
          key="message_logs"
          label="Message Logs"
          disabled={!valid}>
          <Section label="Options">
            <Button
              content="Refresh"
              onClick={() => act('refresh')}
            />
            <Button
              content="Delete All Logs"
              disabled={!(message_logs && message_logs.length)}
              onClick={() => act('delete', {
                'value': 'message_log',
              })}
            />
          </Section>
          <Section label="Messages">
            {(message_logs && message_logs.length) ? (message_logs.map(message => {
              return (
                <Section key={message.ref}>
                  <LabeledList>
                    <LabeledList.Item label="Sender">
                      {message.sender}
                    </LabeledList.Item>
                    <LabeledList.Item label="Recipient">
                      {message.recipient}
                    </LabeledList.Item>
                    <LabeledList.Item
                      label="Message"
                      buttons={(
                        <Fragment>
                          <Button
                            content="Delete"
                            onClick={() => act('delete', {
                              'value': message.ref,
                            })}
                          />
                          {message.image && (
                            <Button // Had to use _act for this.
                              content="Image"
                              onClick={() => _act(message.ref, 'photo')}
                            />
                          )}
                        </Fragment>
                      )}>
                      {message.message}
                    </LabeledList.Item>
                  </LabeledList>
                </Section>
              )})
            ) : (
              'Error: Logs empty'
            )}
          </Section>
        </Tabs.Tab>
        <Tabs.Tab
          key="recon_logs"
          label="Req. Console Logs"
          disabled={!valid}>
          <Section label="Options">
            <Button
              content="Refresh"
              onClick={() => act('refresh')}
            />
            <Button
              content="Delete All Logs"
              disabled={!(recon_logs && recon_logs.length)}
              onClick={() => act('delete', {
                'value': 'recon_logs',
              })}
            />
          </Section>
          <Section label="Requests">
            {(recon_logs && recon_logs.length) ? (recon_logs.map(message => {
              return (
                <Section key={message.ref}>
                  <LabeledList>
                    <LabeledList.Item label="Sending Dep.">
                      {message.sender}
                    </LabeledList.Item>
                    <LabeledList.Item label="Receiving Dep.">
                      {message.recipient}
                    </LabeledList.Item>
                    <LabeledList.Item
                      label="Message"
                      buttons={(
                        <Button
                          content="Delete"
                          onClick={() => act('delete', {
                            'value': message.ref,
                          })}
                        />
                      )}>
                      {message.message}
                    </LabeledList.Item>
                    <LabeledList.Item label="Stamp">
                      {message.stamp ? message.stamp : "null"}
                    </LabeledList.Item>
                    <LabeledList.Item label="ID Auth.">
                      {message.id_auth ? message.id_auth : "null"}
                    </LabeledList.Item>
                    <LabeledList.Item label="Priority">
                      {message.recon_logs ? message.recon_logs : "low"}
                    </LabeledList.Item>
                  </LabeledList>
                </Section>
              )})
            ):(
              'Error: No logs found'
            )}
          </Section>
        </Tabs.Tab>
        <Tabs.Tab
          key="custom_pda"
          label="Set Admin Message"
          disabled={!authenticated}>

        </Tabs.Tab>
      </Tabs>
    </Fragment>
  );
};
