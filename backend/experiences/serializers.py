from django.db import models
from rest_framework import serializers
from .models import Experience


class ExperienceSerializer(serializers.ModelSerializer):
    latitude = serializers.SerializerMethodField()
    longitude = serializers.SerializerMethodField()
    related_experiences = serializers.SerializerMethodField()

    class Meta:
        model = Experience
        fields = '__all__'

    def get_latitude(self, obj):
        return obj.location.y

    def get_longitude(self, obj):
        return obj.location.x

    def get_related_experiences(self, obj):
        related = Experience.objects.filter(is_published=True).exclude(pk=obj.pk).filter(
            models.Q(category=obj.category) | models.Q(region=obj.region)
        )[:3]
        return [{'title': item.title, 'slug': item.slug, 'image_url': item.image_url} for item in related]
