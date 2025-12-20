import { useBackend } from '../backend';
import { Box, Button, Icon, LabeledList, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

export const BorgPanel = (props, context) => {
  const { act, data } = useBackend(context);
  const borg = data.borg || {};
  const cell = data.cell || {};
  const cellPercent = cell.charge / cell.maxcharge;
  const channels = data.channels || [];
  const modules = data.modules || [];
  const upgrades = data.upgrades || [];
  const ais = data.ais || [];
  const laws = data.laws || [];

  const active_upgrades = data.active_upgrades || [];
  const ka_remaining_capacity = data.ka_remaining_capacity || 0;
  return (
    <Window
      title="Borg Panel"
      width={700}
      height={700}>
      <Window.Content scrollable>
        <Section
          title={borg.name}
          buttons={(
            <Button
              icon="pencil-alt"
              content="Rename"
              onClick={() => act('rename')} />
          )}>
          <LabeledList>
            <LabeledList.Item label="Status">
              <Button
                icon={borg.emagged ? 'check-square-o' : 'square-o'}
                content="Emagged"
                selected={borg.emagged}
                onClick={() => act('toggle_emagged')} />
              <Button
                icon={borg.lockdown ? 'check-square-o' : 'square-o'}
                content="Locked Down"
                selected={borg.lockdown}
                onClick={() => act('toggle_lockdown')} />
              <Button
                icon={borg.scrambledcodes ? 'check-square-o' : 'square-o'}
                content="Scrambled Codes"
                selected={borg.scrambledcodes}
                onClick={() => act('toggle_scrambledcodes')} />
            </LabeledList.Item>
            <LabeledList.Item label="Charge">
              {!cell.missing ? (
                <ProgressBar
                  value={cellPercent}>
                  {cell.charge + ' / ' + cell.maxcharge}
                </ProgressBar>
              ) : (
                <span className="color-bad">
                  No cell installed
                </span>
              )}
              <br />
              <Button
                icon="pencil-alt"
                content="Set"
                onClick={() => act('set_charge')} />
              <Button
                icon="eject"
                content="Change"
                onClick={() => act('change_cell')} />
              <Button
                icon="trash"
                content="Remove"
                color="bad"
                onClick={() => act('remove_cell')} />
            </LabeledList.Item>
            <LabeledList.Item label="Radio Channels">
              {channels.map(channel => (
                <Button
                  key={channel.name}
                  icon={channel.installed ? 'check-square-o' : 'square-o'}
                  content={channel.name}
                  selected={channel.installed}
                  onClick={() => act('toggle_radio', {
                    channel: channel.name,
                  })} />
              ))}
            </LabeledList.Item>
            <LabeledList.Item label="Model">
              {modules.map(module => (
                <Button
                  key={module.type}
                  icon={borg.active_module === module.type
                    ? 'check-square-o'
                    : 'square-o'}
                  content={module.name}
                  selected={borg.active_module === module.type}
                  onClick={() => act('setmodule', {
                    module: module.type,
                  })} />
              ))}
            </LabeledList.Item>
            <LabeledList.Item label="Upgrades">
              {upgrades.map(upgrade => {
                if (!upgrade.module_type
                  || (upgrade.module_type.includes(borg.active_module))) {
                  const installedCount
                    = active_upgrades.filter(installed_upgrade =>
                      installed_upgrade.type === upgrade.type).length;
                  const isInstalled = installedCount > 0;
                  return (
                    <>
                      <Button
                        key={upgrade.type}
                        icon={isInstalled ? 'check-square-o' : 'square-o'}
                        content={isInstalled ? `${upgrade.name} ${installedCount
                        && (!upgrade.denied_type || upgrade.maximum_of_type > 1)
                        && upgrade.cost
                        !== null ? `(${installedCount} installed)` : ''}`
                          : upgrade.name}
                        selected={isInstalled}
                        onClick={() => act('toggle_upgrade', {
                          upgrade: upgrade.type,
                        })} />
                      {
                        (!upgrade.denied_type || upgrade.maximum_of_type > 1)
                      && upgrade.cost !== null
                          ? (
                            <>
                              <Button
                                content={<Icon name="plus" />}
                                disabled={ka_remaining_capacity < upgrade.cost
                                || (upgrade.denied_type
                              && (installedCount === upgrade.maximum_of_type))}
                                onClick={() => act('add_upgrade', {
                                  upgrade: upgrade.type,
                                })}
                              />
                              <Button
                                content={<Icon name="minus" />}
                                disabled={!isInstalled}
                                onClick={() => act('remove_upgrade', {
                                  upgrade: upgrade.type,
                                })}
                              />
                            </>
                          ) : ""
                      }
                    </>
                  );
                } })}
            </LabeledList.Item>
            {
              ka_remaining_capacity !== null
              && (
                <LabeledList.Item label="Remaining ka capacity">
                  {ka_remaining_capacity}
                </LabeledList.Item>
              )
            }
            <LabeledList.Item label="Master AI">
              {ais.map(ai => (
                <Button
                  key={ai.ref}
                  icon={ai.connected ? 'check-square-o' : 'square-o'}
                  content={ai.name}
                  selected={ai.connected}
                  onClick={() => act('slavetoai', {
                    slavetoai: ai.ref,
                  })} />
              ))}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section
          title="Laws"
          buttons={(
            <Button
              icon={borg.lawupdate ? 'check-square-o' : 'square-o'}
              content="Lawsync"
              selected={borg.lawupdate}
              onClick={() => act('toggle_lawupdate')} />
          )}>
          {laws.map(law => (
            <Box key={law}>
              {law}
            </Box>
          ))}
        </Section>
      </Window.Content>
    </Window>
  );
};
