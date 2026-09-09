from rest_framework.viewsets import ReadOnlyModelViewSet

from .models import Experience
from .serializers import ExperienceSerializer


class ExperienceViewSet(ReadOnlyModelViewSet):
    serializer_class = ExperienceSerializer
    lookup_field = 'slug'

    def get_queryset(self):
        queryset = Experience.objects.filter(is_published=True)
        category = self.request.query_params.get('category')
        if category:
            queryset = queryset.filter(category=category)
        return queryset
