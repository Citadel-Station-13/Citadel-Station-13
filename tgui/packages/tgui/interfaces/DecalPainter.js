import { useBackend } from '../backend';
import { Box, Button, Section } from '../components';
import { Window } from '../layouts';
import { classes } from 'common/react';

export const DecalPainter = (props, context) => {
  const { act, data } = useBackend(context);
  const decal_list = data.decal_list || [];
  const color_list = data.color_list || [];
  const dir_list = data.dir_list || [];
  return (
    <Window
      width={500}
      height={400}>
      <Window.Content>
        <Section title="Decal Type">
          {decal_list.map(decal => (
            <Button
              key={decal.decal}
              style={{
                width: '48px',
                height: '48px',
                padding: 0,
              }}
              selected={decal.decal === data.decal_style}
              tooltip={decal.name}
              onClick={() => act('select decal', {
                decals: decal.decal,
              })}>
              <Box
                className={classes([
                  'decals32x32',
                  data.decal_dir_text + '-' + decal.decal + (data.decal_color ? '_' + data.decal_color : ''),
                ])}
                style={{
                  transform: 'scale(1.5) translate(17%, 17%)',
                }} />
            </Button>
          ))}
        </Section>
        <Section title="Decal Color">
          {color_list.map(color => {
            return (
              <Button
                key={color.colors}
                style={{
                  width: '48px',
                  height: '48px',
                  padding: 0,
                }}
                tooltip={color.colors === "red"
                  ? "Red"
                  : color.colors === "white"
                    ? "White"
                    : "Yellow"}
                selected={color.colors === data.decal_color}
                onClick={() => act('select color', {
                  colors: color.colors,
                })}>
                <Box
                  className={classes([
                    'decals32x32',
                    data.decal_dir_text + '-' + data.decal_style + (color.colors ? '_' + color.colors : ''),
                  ])}
                  style={{
                    transform: 'scale(1.5) translate(17%, 17%)',
                  }} />
              </Button>
            );
          })}
        </Section>
        <Section title="Decal Direction">
          {dir_list.map(dir => {
            return (
              <Button
                key={dir.dirs}
                style={{
                  width: '48px',
                  height: '48px',
                  padding: 0,
                }}
                tooltip={dir.dirs === 1
                  ? "North"
                  : dir.dirs === 2
                    ? "South"
                    : dir.dirs === 4
                      ? "East"
                      : "West"}
                selected={dir.dirs === data.decal_direction}
                onClick={() => act('selected direction', {
                  dirs: dir.dirs,
                })}>
                <Box
                  className={classes([
                    'decals32x32',
                    (dir.dirs === 1
                      ? "north"
                      : dir.dirs === 2
                        ? "south"
                        : dir.dirs === 4
                          ? "east"
                          : "west")
                      + '-' + data.decal_style + (data.decal_color ? '_' + data.decal_color : ''),
                  ])}
                  style={{
                    transform: 'scale(1.5) translate(17%, 17%)',
                  }} />
              </Button>
            );
          })}
        </Section>
      </Window.Content>
    </Window>
  );
};
