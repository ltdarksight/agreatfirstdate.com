$("#pillar_<%= @event_item.pillar_id %> .pillar-content").find('p.add_new_event').remove().end().append("<%= escape_javascript(render(@event_item)) %>");
Common.init();
