import { Button, Dropdown, Input, Section, Stack } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Data = {
  current_name: string;
  current_assignment: string;
  current_trim: string;
  current_age: string;
  currently_wallet_spoofing: BooleanLike;
};

export const ChameleonCardForge = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    current_name,
    current_assignment,
    current_trim,
    current_age,
    currently_wallet_spoofing,
  } = data;

  return (
    <Window width={500} height={300} theme="syndicate">
      <Window.Content scrollable>
        <Stack width="100%" height="50%">
          <Section title="Name">
            <Stack.Item inline width="33%" height="100%">
              <Input value={current_name} placeholder="Enter name" />
            </Stack.Item>
          </Section>
          <Section title="Assignment">
            <Stack.Item inline width="33%" height="100%">
              <Input value={current_assignment} placeholder="Enter job" />
            </Stack.Item>
          </Section>
          <Section title="ID Trim">
            <Stack.Item inline width="33%" height="100%">
              <Dropdown
                options={['One', 'Two', 'Three']}
                overflow="visible"
                over
                menuWidth={20}
                selected={null}
                onSelected={() => {}}
              />
            </Stack.Item>
          </Section>
        </Stack>
        <Stack width="100%" height="50%">
          <Stack.Item width="50%" height="100%">
            <Section title="ID Age">Age </Section>
          </Stack.Item>
          <Stack.Item inline width="50%" height="100%">
            <Section title="Wallet Spoofing">
              <Button
                content={
                  currently_wallet_spoofing ? 'Stop Spoofing' : 'Start Spoofing'
                }
                color={currently_wallet_spoofing ? 'red' : 'green'}
              />
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
