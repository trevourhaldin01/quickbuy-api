import { EmailEventListener } from "@vendure/email-plugin";
import { OrderPlacedEvent } from "@vendure/core";

export const adminOrderNotification = new EmailEventListener('admin-order-notification')
    .on(OrderPlacedEvent)
    .setRecipient(() => 'limogodwill@gmail.com')
    .setFrom('admin@pulsetechuganda.com')
    .setSubject(event => `New Order #${event.order.code}`)
    .setTemplateVars(event => ({
        order: event.order,
    }));
