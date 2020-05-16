import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { act as _act } from '../byond';
import { Button, LabeledList, NoticeBox, Section, Tabs, Input } from '../components';

export const TelePDALog = props => {
  const { act, data } = useBackend(props);
  const {
    network,
    notice = "",
    authenticated = false,
    status = true,
    canhack = false,
    selected = null,
    servers = [],
    message_logs = [],
    recon_logs = [],
  } = data;
  const fake_message = data.fake_message || {
    'sender': 'System Administrator',
    'job': 'Admin',
    'recepient': null,
    'message': 'This is a test, please ignore',
  };
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
                    color="bad"
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
                  content={!authenticated ? 'Login' : 'Logout'}
                  icon={authenticated ? 'unlock' : 'lock'}
                  color={authenticated ? 'good' : 'bad'}
                  disabled={!selected}
                  onClick={() => act('auth')}
                />
                <Button
                  content="Disconnect"
                  icon="minus-circle"
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
          <Section title="Logs">
            <Button
              content="Refresh"
              onClick={() => act('refresh')}
            />
            <Button
              content="Delete All Logs"
              disabled={!(message_logs && message_logs.length)}
              onClick={() => act('clear_log', {
                'value': 'pda_logs',
              })}
            />
            <Section
              title="Messages"
              level={2}>
              {(message_logs && message_logs.length) ? (
                message_logs.map(message => {
                  return (
                    <Section key={message.ref}>
                      <LabeledList>
                        <LabeledList.Item label="Sender"
                          buttons={(
                            <Button
                              content="Delete"
                              onClick={() => act('del_log', {
                                'ref': message.ref,
                              })}
                            />
                          )}>
                          {message.sender}
                        </LabeledList.Item>
                        <LabeledList.Item label="Recipient">
                          {message.recipient}
                        </LabeledList.Item>
                        <LabeledList.Item
                          label="Message"
                          buttons={(
                            message.image && (
                              <Button // Had to use _act for this.
                                content="Image"
                                onClick={() => _act(message.ref, 'photo')}
                              />
                            )
                          )}>
                          {message.message}
                        </LabeledList.Item>
                      </LabeledList>
                    </Section>
                  );
                })
              ) : (
                'Error: Logs empty'
              )}
            </Section>
          </Section>
        </Tabs.Tab>
        <Tabs.Tab
          key="recon_logs"
          label="Req. Console Logs"
          disabled={!valid}>
          <Section title="Logs">
            <Button
              content="Refresh"
              onClick={() => act('refresh')}
            />
            <Button
              content="Delete All Logs"
              disabled={!(recon_logs && recon_logs.length)}
              onClick={() => act('clear_log', {
                'value': 'rc_msgs',
              })}
            />
            <Section
              title="Requests"
              level={2}>
              {(recon_logs && recon_logs.length) ? (
                recon_logs.map(message => {
                  return (
                    <Section key={message.ref}>
                      <LabeledList>
                        <LabeledList.Item label="Sending Dep."
                          buttons={(
                            <Button
                              content="Delete"
                              onClick={() => act('del_log', {
                                'ref': message.ref,
                              })}
                            />
                          )}>
                          {message.sender}
                        </LabeledList.Item>
                        <LabeledList.Item label="Receiving Dep.">
                          {message.recipient}
                        </LabeledList.Item>
                        <LabeledList.Item label="Message">
                          {message.message}
                        </LabeledList.Item>
                        <LabeledList.Item label="Stamp">
                          {message.stamp}
                        </LabeledList.Item>
                        <LabeledList.Item label="ID Authentication">
                          {message.auth}
                        </LabeledList.Item>
                        <LabeledList.Item label="Priority">
                          {message.priority}
                        </LabeledList.Item>
                      </LabeledList>
                    </Section>
                  );
                })
              ) : (
                'Error: No logs found'
              )}
            </Section>
          </Section>
        </Tabs.Tab>
        <Tabs.Tab
          key="custom_pda"
          label="Set Admin Message"
          disabled={!authenticated}>
          <Section title="Custom Message">
            <Button
              content="Reset"
              icon="sync"
              onClick={() => act('fake', {
                'reset': true,
              })}
            />
            <Button
              content="Send"
              onClick={() => act('fake', {
                'send': true,
              })}
            />
            <br /><br />
            <LabeledList>
              <LabeledList.Item label="Sender">
                <Input
                  value={fake_message.sender}
                  width="250px"
                  maxLength={255}
                  onChange={(e, value) => act('fake', {
                    'sender': value,
                  })}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Sender's Job">
                <Input
                  value={fake_message.job}
                  width="250px"
                  maxLength={255}
                  onChange={(e, value) => act('fake', {
                    'job': value,
                  })}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Recipient">
                <Button
                  content={fake_message.recepient ? (
                    fake_message.recepient
                  ) : (
                    'Select'
                  )}
                  onClick={() => act('fake', {
                    'recepient': true,
                  })}
                />
              </LabeledList.Item>
              <LabeledList.Item label="Message">
                <Input
                  value={fake_message.message}
                  width="500px"
                  height="150px"
                  maxLength={2000}
                  onChange={(e, value) => act('fake', {
                    'message': value,
                  })}
                />
              </LabeledList.Item>
            </LabeledList>
          </Section>
        </Tabs.Tab>
      </Tabs>
    </Fragment>
  );
};
