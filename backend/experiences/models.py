from django.contrib.gis.db import models


class Experience(models.Model):
    class Category(models.TextChoices):
        HISTORY = 'history', 'History'
        NATURE = 'nature', 'Nature'
        CULTURE = 'culture', 'Culture'
        REST = 'rest', 'Rest'

    class Tier(models.TextChoices):
        SIGNATURE = 'signature', 'Signature'
        FEATURED = 'featured', 'Featured'
        HIDDEN_GEM = 'hidden_gem', 'Hidden Gem'

    title = models.CharField(max_length=160)
    slug = models.SlugField(unique=True)
    category = models.CharField(max_length=20, choices=Category.choices)
    tier = models.CharField(max_length=20, choices=Tier.choices)
    region = models.CharField(max_length=80)
    address = models.CharField(max_length=255)
    image_url = models.URLField()
    audio_url = models.URLField(blank=True)
    location = models.PointField(geography=True, srid=4326)
    time_commitment = models.CharField(max_length=80)
    physical_level = models.CharField(max_length=40)
    entry_fee_foreigner = models.CharField(max_length=80)
    description = models.TextField()
    opening_hours = models.CharField(max_length=255)
    best_time_to_visit = models.CharField(max_length=255)
    what_to_bring = models.TextField()
    getting_there = models.TextField()
    bullet_points = models.JSONField(default=list)
    is_bookable = models.BooleanField(default=False)
    booking_url = models.URLField(blank=True)
    is_published = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        indexes = [models.Index(fields=['category', 'region']), models.Index(fields=['is_published'])]
        ordering = ['title']

    def __str__(self):
        return self.title
