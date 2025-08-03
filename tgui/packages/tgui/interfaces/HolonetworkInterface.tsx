import { Button, Section, Stack } from 'tgui-core/components';
import { useBackend } from '../backend';
import { Window } from '../layouts';

type WaitingRequestData = {
  connecting_from_callsign: string;
  connecting_from_ref: string;
  participant_callsigns: string[];
};

type HolonetIFData = {
  available_interfaces: [string, string][];
  waiting: WaitingRequestData[];
};

const CallWaitingScreen = (props: WaitingRequestData[]) => {
  const { act, data } = useBackend<HolonetIFData>();

  return (
    <Section align="center" title="Calls Waiting">
      <Stack vertical>
        {Object.keys(props).map((call_waiting) => (
          <Stack.Item key={props[call_waiting].connecting_from_callsign}>
            <Section title={props[call_waiting].connecting_from_callsign}>
              <Button onClick={() => act('accept_request', {accepted: props[call_waiting].connecting_from_ref})} color="good">Answer</Button>
              <Button color="bad">Reject</Button>
            </Section>
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};

export function HolonetworkInterface(props: HolonetIFData) {
  const { data, act } = useBackend<HolonetIFData>();
  const { available_interfaces, waiting } = data;
  return (
    <Window width={400} height={400}>
      <Window.Content>
        <Section scrollable align="center">
          {!waiting.length ? (
            <Stack fill vertical>
              {Object.keys(available_interfaces).map((interface_name) => (
                <Stack.Item className="candystripe" key={interface_name}>
                  <Button
                    onClick={() =>
                      act('send_call_request', { target: interface_name })
                    }
                  >
                    {interface_name}
                  </Button>
                </Stack.Item>
              ))}
            </Stack>
          ) : (
            <CallWaitingScreen {...waiting} />
          )}
        </Section>
      </Window.Content>
    </Window>
  );
}
