import { Fragment } from 'inferno';
import { useBackend } from '../backend';
import { Button, LabeledList, NoticeBox, Section, Tabs, Input } from '../components';

export const TelePDALog = props => {
  const { act, data } = useBackend(props);
  const {
    authenticated = false,
    status = true,
    canhack = false,
    selected = null,
    message_logs = [],
    recon_logs = [],
  } = data;
  const valid = (status && selected && authenticated);

  if(data.hacking) {
    return ( //should have used en -> jp unicode -> other encoding method -> utf8
      <Fragment>
        <NoticeBox>
          {"%$�(�:SYS&EM INTRN@L ACfES VIOL�TIa█ DEtE₡TED! Ree3ARcinG A█ BAaKUP RdST�RE PbINT [0xcff32ca/ - PLfASE aAIT"}
        </NoticeBox>
        <Section>
          {data.hacking_msg}
        </Section>
      </Fragment> //Custom text because ai gets to see normaltext while people see binary
    );
  }

  return (
    <Fragment>
      <Section title="Network Control">
        <LabeledList>
          <LabeledList.Item
            label="Authentication"
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
                  disabled={authenticated || !selected}
                  onClick={() => act('auth')}
                />
                <Button
                  content="Disconnect"
                  disabled={!selected}
                  onClick={() => act('disconnect')}
                />
              </Fragment>
            )}>
            {selected ? selected.name : "No Server!"}
          </LabeledList.Item>
          <LabeledList.Item
            label="PDA Server Status"
            color={status ? 'good' : 'bad'}
            >
            {status ? 'Running' : 'Server down! Log functionality unaccessable!'}
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Tabs vertical>
        <Tabs.Tab
          key="servers"
          label="Servers">

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
              content="Delete Logs"
              onClick={() => act('delete', {
                'value':'message_log'
              })}
              />
          </Section>
          <Section>
            {message_logs.map(message => {
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
                        <Button
                          content="Delete"
                          onClick={() => act('delete', {
                            'value':message.ref
                          })}
                        />
                      )}>
                      {message.message}
                    </LabeledList.Item>
                  </LabeledList>
                </Section>
              )
            })}
          </Section>
        </Tabs.Tab>
        <Tabs.Tab
          key="recon_logs"
          label="Request Console Logs"
          disabled={!valid}>
          <Section label="Options">
            <Button
              content="Refresh"
              onClick={() => act('refresh')}
              />
            <Button
              content="Delete Logs"
              onClick={() => act('delete', {
                'value':'recon_logs'
              })}
              />
          </Section>
          <Section>
            {recon_logs.map(message => {
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
                            'value':message.ref
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
              )
            })}
          </Section>
        </Tabs.Tab>
        <Tabs.Tab
          key="custom_pda"
          label="Set Admin Message"
          disabled={!authenticated}>

        </Tabs.Tab>
      </Tabs>
    </Fragment>
  )
}
