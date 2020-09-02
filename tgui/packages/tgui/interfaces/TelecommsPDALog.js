/**
 * @file
 * @copyright 2020 LetterN (https://github.com/LetterN)
 * @license MIT
 */
import { Fragment } from 'inferno';
import { Window } from '../layouts';
import { useBackend, useSharedState } from '../backend';
import { Button, LabeledList, NoticeBox, Section, Tabs, Input } from '../components';

// This is the entrypoint, don't mind the others
export const TelecommsPDALog = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    network,
    notice = "",
    authenticated = false,
    canhack = false,
    silicon = false,
    hack_status = null,
    selected = null,
    servers = [],
  } = data;
  const [
    tab,
    setTab,
  ] = useSharedState(context, 'tab', 'pdalog-servers');
  const valid = (selected && selected.status && authenticated);
  if (hack_status) {
    return ( // should have used en -> jp unicode -> other encoding method->utf8
      <Window
        theme="ntos"
        resizable
        width={727}
        height={510}>
        <Window.Content scrollable>
          <NoticeBox>
            <b>
              <h3>
                {"INTRN@L ACfES VIOL�TIa█ DEtE₡TED! Ree3ARcinG A█ \
                BAaKUP RdST�RE PbINT [0xcff32ca] - PLfASE aAIT"}
              </h3>
            </b>
            <i>
              {(silicon && !hack_status.emagging) ? (
                <Fragment>
                  Brute-forcing for server key. <br />
                  It will take 20 seconds for every character that
                  the password has.
                  <br />
                  In the meantime, this console can reveal your
                  true intentions if you let someone access it.
                  Make sure no humans enter the room during that time.
                </Fragment>
              ) : (
                <Fragment>
                  QnJ1dGUtZm9yY2luZyBmb3Igc2VydmVyIGtleS48YnI+IEl0IHdpbG<br />
                  wgdGFrZSAyMCBzZWNvbmRzIGZvciBldmVyeSBjaGFyYWN0ZXIgdGhh<br />
                  dCB0aGUgcGFzc3dvcmQgaGFzLiBJbiB0aGUgbWVhbnRpbWUsIHRoaX<br />
                  MgY29uc29sZSBjYW4gcmV2ZWFsIHlvdXIgdHJ1ZSBpbnRlbnRpb25z<br />
                  IGlmIHlvdSBsZXQgc29tZW9uZSBhY2Nlc3MgaXQuIE1ha2Ugc3VyZS<br />
                  BubyBodW1hbnMgZW50ZXIgdGhlIHJvb20gZHVyaW5nIHRoYXQgdGltZS4=
                  <br /><br />
                </Fragment>
              )}
            </i>
          </NoticeBox>
        </Window.Content>
      </Window>
    );
  }

  return (
    <Window theme="ntos" resizable>
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
                      onClick={() => act('change_auth')}
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
                color={(selected && selected.status) ? 'good' : 'bad'}>
                {selected ? (
                  selected.status ? (
                    'Running'
                  ) : (
                    `Server down! Logging and messaging
                    functionality unavailable!`
                  )
                ):(
                  'No server selected'
                )}
              </LabeledList.Item>
            </LabeledList>
          </Section>
          <Tabs>
            <Tabs.Tab
              icon="server"
              selected={tab === "pdalog-servers"}
              onClick={() => setTab("pdalog-servers")}>
              Servers
            </Tabs.Tab>
            <Tabs.Tab
              disabled={!valid}
              icon="file"
              selected={tab === "pdalog-message"}
              onClick={() => setTab("pdalog-message")}>
              Message Logs
            </Tabs.Tab>
            <Tabs.Tab
              disabled={!valid}
              icon="file"
              selected={tab === "pdalog-reqmsg"}
              onClick={() => setTab("pdalog-reqmsg")}>
              Req. Console Logs
            </Tabs.Tab>
            <Tabs.Tab
              disabled={!valid}
              icon="server"
              selected={tab === "pdalog-custommsg"}
              onClick={() => setTab("pdalog-custommsg")}>
              Set Admin Message
            </Tabs.Tab>
          </Tabs>
          {tab === "pdalog-servers" ? (
            <Section>
              {(servers && servers.length) ? (
                <LabeledList>
                  {servers.map(server => (
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
                  ))}
                </LabeledList>
              ) : (
                '404 Servers not found. Have you tried scanning the network?'
              )}
            </Section>
          ) : (
            <Fragment>
              {(tab === "pdalog-message" && authenticated) && (
                <TeleLogs />
              )}
              {(tab === "pdalog-reqmsg" && authenticated) && (
                <TeleLogs msgs_log />
              )}
              {(tab === "pdalog-custommsg" && authenticated) && (
                <CustomMsg />
              )}
            </Fragment>
          )}
        </Fragment>
      </Window.Content>
    </Window>
  );
};

// They're the same, so merged it into this. Idea stolen from cargonia
export const TeleLogs = (props, context) => {
  const {
    msgs_log = false, // <TeleLogs msgs_log/>
  } = props;
  const { act, data } = useBackend(context);
  const {
    message_logs = [],
    recon_logs = [],
  } = data;
  const prioritycolorMap = {
    'Normal': 'warning',
    'High': 'bad',
    'Extreme': 'bad',
  };
  const log_to_use = (msgs_log ? recon_logs : message_logs) || [];
  return (
    <Section title="Logs">
      <Button
        content="Refresh"
        icon="sync"
        onClick={() => act('refresh')}
      />
      <Button.Confirm
        content="Delete All Logs"
        icon="trash"
        disabled={!log_to_use || !(log_to_use && log_to_use.length)}
        onClick={() => act('clear_log', {
          'value': msgs_log ? 'rc_msgs' : 'pda_logs',
        })}
      />
      <Section
        title="Messages"
        level={2}>
        {log_to_use?.map(message => (
          <Section key={message.ref}>
            <LabeledList>
              <LabeledList.Item
                label={msgs_log ? "Sending Dep." : "Sender"}
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
              <LabeledList.Item
                label={msgs_log ? "Receiving Dep." : "Recipient"}>
                {message.recipient}
              </LabeledList.Item>
              <LabeledList.Item
                label="Message"
                buttons={(
                  !!message.picture && ( // don't send img over req
                    <Button // Had to use _act for this.
                      content="Image"
                      icon="image"
                      onClick={() => Byond.topic({
                        'src': message.ref,
                        'photo': 1,
                      })}
                    />
                  )
                )}>
                {message.message}
              </LabeledList.Item>
              {!!msgs_log && (
                <Fragment>
                  <LabeledList.Item
                    label="Stamp"
                    color={message.stamp !== "Unstamped" ? (
                      'label'
                    ) : (
                      'bad'
                    )}
                    bold={message.stamp !== 'Unstamped'}>
                    {message.stamp}
                  </LabeledList.Item>
                  <LabeledList.Item
                    label="ID Authentication"
                    color={message.auth !== "Unauthenticated" ? (
                      'good'
                    ) : (
                      'bad'
                    )}>
                    {message.auth}
                  </LabeledList.Item>
                  <LabeledList.Item
                    label="Priority"
                    color={(message.priority in prioritycolorMap) ? (
                      prioritycolorMap[message.priority]
                    ) : (
                      'good'
                    )}
                    bold={message.priority === 'Extreme'}>
                    {message.priority === 'Extreme' ? (
                      `!!${message.priority}!!`
                    ) : (
                      message.priority
                    )}
                  </LabeledList.Item>
                </Fragment>
              )}
            </LabeledList>
          </Section>
        ))}
      </Section>
    </Section>
  );
};

export const CustomMsg = (props, context) => {
  const { act, data } = useBackend(context);
  const fake_message = data.fake_message || {
    'sender': 'System Administrator',
    'job': 'Admin',
    'recepient': null,
    'message': 'This is a test, please ignore',
  };
  return (
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
        disabled={!fake_message.recepient || !fake_message.message}
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
            maxLength={42}
            onChange={(e, value) => act('fake', {
              'sender': value,
            })}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Sender's Job">
          <Input
            value={fake_message.job}
            width="250px"
            maxLength={100}
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
            selected={fake_message.recepient}
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
            maxLength={2048}
            onChange={(e, value) => act('fake', {
              'message': value,
            })}
          />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
