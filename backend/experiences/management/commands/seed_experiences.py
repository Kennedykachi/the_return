from django.contrib.gis.geos import Point
from django.core.management.base import BaseCommand

from experiences.models import Experience


EXPERIENCES = [
    {
        'title': 'Cape Coast Castle', 'slug': 'cape-coast-castle', 'category': 'history', 'region': 'Central',
        'image_url': 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee', 'audio_url': '',
        'location': Point(-1.2466, 5.1053), 'time_commitment': '2–3 hours', 'physical_level': 'Easy',
        'entry_fee_foreigner': 'GHS 100',
        'description': 'Stand within one of Ghana’s most significant coastal landmarks and trace the human stories held in its courtyards, chambers, and ocean-facing walls.',
        'opening_hours': 'Mon–Sun, 9:00–16:30', 'best_time_to_visit': 'Early morning or late afternoon',
        'what_to_bring': 'Water, sun protection, and comfortable shoes.', 'getting_there': 'A 10-minute walk from central Cape Coast.',
        'bullet_points': ['Join a guided castle tour', 'Visit the West African Historical Museum', 'Walk the Atlantic-facing ramparts'],
    },
    {
        'title': 'Kakum National Park', 'slug': 'kakum-national-park', 'category': 'nature', 'region': 'Central',
        'image_url': 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e', 'audio_url': '',
        'location': Point(-1.3728, 5.3539), 'time_commitment': '3–4 hours', 'physical_level': 'Moderate',
        'entry_fee_foreigner': 'GHS 150',
        'description': 'Walk above a living rainforest on a canopy bridge suspended in the treetops, where forest sounds and wide green horizons make the journey the destination.',
        'opening_hours': 'Daily, 6:00–16:00', 'best_time_to_visit': 'Morning, before the heat',
        'what_to_bring': 'Closed shoes, water, insect repellent.', 'getting_there': 'About 35 minutes by road from Cape Coast.',
        'bullet_points': ['Walk seven suspension bridges', 'Spot rainforest birds', 'Take a guided forest trail'],
    },
    {
        'title': 'W.E.B. Du Bois Memorial Centre', 'slug': 'web-du-bois-memorial-centre', 'category': 'culture', 'region': 'Greater Accra',
        'image_url': 'https://images.unsplash.com/photo-1548013146-72479768bada', 'audio_url': '',
        'location': Point(-0.1880, 5.5599), 'time_commitment': '1–2 hours', 'physical_level': 'Easy',
        'entry_fee_foreigner': 'GHS 50',
        'description': 'A quiet Accra home turned memorial, connecting the ideas, final years, and legacy of the scholar and Pan-Africanist W.E.B. Du Bois.',
        'opening_hours': 'Tue–Sun, 9:00–17:00', 'best_time_to_visit': 'Weekday mornings',
        'what_to_bring': 'A notebook and a curious mind.', 'getting_there': 'Located in Cantonments, Accra; taxi access is easiest.',
        'bullet_points': ['See Du Bois’s library', 'Visit the mausoleum', 'Explore Pan-African history'],
    },
]


class Command(BaseCommand):
    help = 'Create starter Experience Ghana content.'

    def handle(self, *args, **options):
        for data in EXPERIENCES:
            Experience.objects.update_or_create(slug=data['slug'], defaults={**data, 'is_published': True})
        self.stdout.write(self.style.SUCCESS(f'Seeded {len(EXPERIENCES)} experiences.'))
