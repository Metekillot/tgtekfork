import { Button, Section, Stack } from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type HolonetIFData = {
  available_interfaces: [string, string][];
};

export function HolonetworkInterface(props: HolonetIFData) {
  const { data } = useBackend<HolonetIFData>();
  const { available_interfaces } = data;
  return (
    <Window width={400} height={400}>
      <Window.Content>
        <Section scrollable align="center">
          <Stack fill vertical>
            {Object.keys(available_interfaces).map((interface_name) => (
              <Stack.Item className="candystripe" key={interface_name}>
                <Button>{interface_name}</Button>
              </Stack.Item>
            ))}
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
}
